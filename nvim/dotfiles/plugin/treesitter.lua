-- nvim-treesitter `main` branch.
--
-- The legacy `master` API (`require("nvim-treesitter.configs").setup`) is gone:
-- parsers are installed imperatively, highlighting/indent are enabled per
-- buffer, and textobjects keymaps are set manually.

local treesitter = require("nvim-treesitter")

-- Install every available parser except known bad actors. `install` is async
-- and skips parsers that are already installed.
local ignore_install = { wing = true, ipkg = true }
treesitter.install(vim.tbl_filter(function(lang)
    return not ignore_install[lang]
end, treesitter.get_available()))

-- Enable highlighting per buffer (no global `highlight = { enable = true }`
-- anymore). `vim.treesitter.start` errors for filetypes without a parser, so
-- guard it.
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-- Folding via native treesitter.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

--------------------------------------------------------------------------------
-- Incremental selection (removed from the `main` rewrite, reimplemented here).
--------------------------------------------------------------------------------
do
    local state = {} -- buffer -> stack of TSNodes, growing outward

    local function range_eq(a, b)
        local a1, a2, a3, a4 = a:range()
        local b1, b2, b3, b4 = b:range()
        return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
    end

    local function line_span(node)
        local srow, _, erow = node:range()
        return erow - srow
    end

    -- Visually select a node, normalizing whatever mode we are currently in.
    local function select_node(node)
        local srow, scol, erow, ecol = node:range() -- 0-indexed, end-exclusive
        if vim.fn.mode():match("[vV\22]") then
            vim.cmd("normal! \27") -- <Esc> out of any visual mode first
        end
        vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
        vim.cmd("normal! v")
        if ecol == 0 then
            -- Node ends at column 0 of `erow`: select to the end of the
            -- previous line instead.
            vim.api.nvim_win_set_cursor(0, { erow, 0 })
            vim.cmd("normal! $")
        else
            vim.api.nvim_win_set_cursor(0, { erow + 1, ecol - 1 })
        end
    end

    -- Smallest enclosing parent with a strictly larger range.
    local function bigger_parent(node)
        local parent = node:parent()
        while parent and range_eq(parent, node) do
            parent = parent:parent()
        end
        return parent
    end

    local function init_selection()
        local buf = vim.api.nvim_get_current_buf()
        local node = vim.treesitter.get_node()
        if not node then
            return
        end
        state[buf] = { node }
        select_node(node)
    end

    local function node_incremental()
        local buf = vim.api.nvim_get_current_buf()
        local stack = state[buf]
        if not stack or #stack == 0 then
            return init_selection()
        end
        local parent = bigger_parent(stack[#stack])
        if parent then
            table.insert(stack, parent)
        end
        select_node(stack[#stack])
    end

    local function node_decremental()
        local buf = vim.api.nvim_get_current_buf()
        local stack = state[buf]
        if not stack or #stack == 0 then
            return
        end
        if #stack > 1 then
            table.remove(stack)
        end
        select_node(stack[#stack])
    end

    -- Expand outward until the selection covers at least one more line.
    local function scope_incremental()
        local buf = vim.api.nvim_get_current_buf()
        local stack = state[buf]
        if not stack or #stack == 0 then
            return init_selection()
        end
        local base = line_span(stack[#stack])
        repeat
            local parent = bigger_parent(stack[#stack])
            if not parent then
                break
            end
            table.insert(stack, parent)
        until line_span(stack[#stack]) > base
        select_node(stack[#stack])
    end

    vim.keymap.set("n", "v]", init_selection, { desc = "Init treesitter selection." })
    vim.keymap.set("x", "=", node_incremental, { desc = "Increment node selection." })
    vim.keymap.set("x", "-", node_decremental, { desc = "Decrement node selection." })
    vim.keymap.set("x", "]", scope_incremental, { desc = "Increment scope selection." })
end

--------------------------------------------------------------------------------
-- Textobjects
--------------------------------------------------------------------------------
require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
        selection_modes = {
            -- charwise v
            ["@parameter.inner"] = "v",
            ["@parameter.outer"] = "v",
            -- linewise V
            ["@return.inner"] = "V",
            ["@return.outer"] = "V",
            ["@block.inner"] = "V",
            ["@block.outer"] = "V",
            ["@function.inner"] = "V",
            ["@function.outer"] = "V",
            ["@class.inner"] = "V",
            ["@class.outer"] = "V",
            ["@statement.outer"] = "V",
            -- blockwise <c-v>
        },
        include_surrounding_whitespace = false,
    },
    move = {
        set_jumps = true,
    },
})

-- Select
local select_to = require("nvim-treesitter-textobjects.select")
local function select_textobject(lhs, query, desc)
    vim.keymap.set({ "x", "o" }, lhs, function()
        select_to.select_textobject(query, "textobjects")
    end, { desc = desc })
end

select_textobject("ip", "@parameter.inner", "Select inner part of a parameter.")
select_textobject("ap", "@parameter.outer", "Select outer part of a parameter.")
select_textobject("ir", "@return.inner", "Select inner part of a return.")
select_textobject("ar", "@return.outer", "Select outer part of a return.")
select_textobject("ib", "@block.inner", "Select inner part of a block.")
select_textobject("ab", "@block.outer", "Select outer part of a block.")
select_textobject("if", "@function.inner", "Select inner part of a function.")
select_textobject("af", "@function.outer", "Select outer part of a function.")
select_textobject("ic", "@class.inner", "Select inner part of a class.")
select_textobject("ac", "@class.outer", "Select outer part of a class.")
select_textobject("a/", "@comment.outer", "Select outer part of a comment.")
select_textobject("as", "@statement.outer", "Select outer part of a statement.")

-- Swap
local swap = require("nvim-treesitter-textobjects.swap")
vim.keymap.set("n", "<leader>.", function()
    swap.swap_next("@parameter.inner")
end, { desc = "Swap with next parameter." })
vim.keymap.set("n", "<leader>,", function()
    swap.swap_previous("@parameter.inner")
end, { desc = "Swap with previous parameter." })

-- Move
local move = require("nvim-treesitter-textobjects.move")
local function move_to(lhs, fn, query, desc)
    vim.keymap.set({ "n", "x", "o" }, lhs, function()
        fn(query, "textobjects")
    end, { desc = desc })
end

move_to("]p", move.goto_next_start, "@parameter.inner", "Start of next parameter.")
move_to("]f", move.goto_next_start, "@function.outer", "Start of next function.")
move_to("]c", move.goto_next_start, "@class.outer", "Start of next class.")

move_to("[p", move.goto_previous_start, "@parameter.inner", "Start of previous parameter.")
move_to("[f", move.goto_previous_start, "@function.outer", "Start of previous function.")
move_to("[c", move.goto_previous_start, "@class.outer", "Start of previous class.")

move_to("]P", move.goto_next_end, "@parameter.inner", "End of next parameter.")
move_to("]F", move.goto_next_end, "@function.outer", "End of next function.")
move_to("]C", move.goto_next_end, "@class.outer", "End of next class.")

move_to("[P", move.goto_previous_end, "@parameter.inner", "End of previous parameter.")
move_to("[F", move.goto_previous_end, "@function.outer", "End of previous function.")
move_to("[C", move.goto_previous_end, "@class.outer", "End of previous class.")
