-- Three way merge of the buffer with external changes to the file on disk.
--
-- When a file changes on disk while the buffer holds unsaved changes, Vim can only offer to keep
-- one of the two sides. Instead, a snapshot of the file is kept every time it is read or written,
-- and used as the merge base to combine both sets of changes. The result stays unsaved so that
-- conflicts, which appear as regular conflict markers, can be reviewed before writing.

local base_dir = vim.fn.stdpath("cache") .. "/merge-base"
vim.fn.mkdir(base_dir, "p")

local function is_file_buffer(buf)
    return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
end

local function base_path(buf)
    return base_dir .. "/" .. vim.fn.sha256(vim.api.nvim_buf_get_name(buf))
end

local function buf_lines(buf)
    return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
end

--- Content of the file on disk, as it would appear in the buffer.
--- Line endings are normalized so that they never take part in the merge.
local function disk_lines(buf)
    local lines = vim.fn.readfile(vim.api.nvim_buf_get_name(buf))
    if vim.bo[buf].fileformat == "dos" then
        for i, line in ipairs(lines) do
            lines[i] = line:gsub("\r$", "")
        end
    end
    return lines
end

local function write_base(buf, lines)
    pcall(vim.fn.writefile, lines, base_path(buf))
end

local function set_lines_keep_view(buf, lines)
    local views = {}
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        views[win] = vim.api.nvim_win_call(win, vim.fn.winsaveview)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    for win, view in pairs(views) do
        vim.api.nvim_win_call(win, function()
            vim.fn.winrestview(view)
        end)
    end
end

local function merge(buf)
    local base = base_path(buf)
    if vim.fn.filereadable(base) == 0 then
        vim.notify(
            "No merge base for " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t"),
            vim.log.levels.ERROR
        )
        return
    end

    local ok, disk = pcall(disk_lines, buf)
    if not ok then
        vim.notify("Cannot read file from disk: " .. disk, vim.log.levels.ERROR)
        return
    end

    local mine, theirs = vim.fn.tempname(), vim.fn.tempname()
    vim.fn.writefile(buf_lines(buf), mine)
    vim.fn.writefile(disk, theirs)
    -- Merges in place into the first file.
    vim.fn.system({ "git", "merge-file", "-L", "buffer", "-L", "base", "-L", "disk", mine, base, theirs })
    -- The exit status is the number of conflicts, or above 127 when the merge itself failed.
    local conflicts = vim.v.shell_error
    if conflicts < 0 or conflicts > 127 then
        vim.notify("Merge with the file on disk failed, buffer left untouched", vim.log.levels.ERROR)
        return
    end

    set_lines_keep_view(buf, vim.fn.readfile(mine))
    -- The disk content is now part of the buffer, so it becomes the base for the next change.
    write_base(buf, disk)

    if conflicts > 0 then
        vim.notify(("Merged the file on disk with %d conflict(s)"):format(conflicts), vim.log.levels.WARN)
    else
        vim.notify("Merged the file on disk cleanly", vim.log.levels.INFO)
    end
end

local group = vim.api.nvim_create_augroup("dotfiles_merge_on_change", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
    group = group,
    callback = function(args)
        if is_file_buffer(args.buf) then
            write_base(args.buf, buf_lines(args.buf))
        end
    end,
})

vim.api.nvim_create_autocmd("BufUnload", {
    group = group,
    callback = function(args)
        if is_file_buffer(args.buf) then
            pcall(vim.fn.delete, base_path(args.buf))
        end
    end,
})

vim.api.nvim_create_autocmd("FileChangedShell", {
    group = group,
    callback = function(args)
        local reason = vim.v.fcs_reason
        local modified = vim.bo[args.buf].modified

        if reason == "changed" or reason == "conflict" then
            if not modified then
                vim.v.fcs_choice = "reload"
            else
                -- Changing the buffer is not allowed from this event, and the buffer must stay
                -- modified for the merge result to be reviewed, so Vim is told to do nothing.
                vim.v.fcs_choice = ""
                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].modified then
                        merge(args.buf)
                    end
                end)
            end
        elseif reason == "mode" then
            vim.v.fcs_choice = modified and "" or "reload"
        elseif reason == "time" then
            vim.v.fcs_choice = ""
        else
            -- Deletions, and whatever Vim may add later, are left to the default prompt.
            vim.v.fcs_choice = "ask"
        end
    end,
})

vim.api.nvim_create_user_command("DiffDisk", function()
    vim.cmd([[
        vertical new
        setlocal buftype=nofile bufhidden=wipe nobuflisted
        read ++edit #
        0delete _
        diffthis
        wincmd p
        diffthis
    ]])
end, { desc = "Diff the buffer against the file on disk" })
