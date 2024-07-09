-- Line numbers
vim.opt.number = true

-- Activate mouse
vim.opt.mouse = "a"

-- Hidden characters
vim.opt.list = true
vim.opt.listchars =
    { eol = "¬", tab = "──", trail = "·", nbsp = "⌴", extends = "…", precedes = "…" }
vim.opt.fillchars = {}

-- Soft wrap lines with indent
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.showbreak = "↳"

-- Show vertical rule at column
vim.opt.colorcolumn = "100"

-- Show command at the bottom right
vim.opt.showcmd = true

-- Default folding level when opening new buffer
vim.opt.foldlevelstart = 99

-- Use full color scale
vim.cmd([[set termguicolors]])

local function simple_on_file_change(path, callback)
	handle = vim.uv.new_fs_event()
	if not handle then
		return nil
	end

	local flags = {
		watch_entry = false, -- when dir, watch dir inode, not dir content
		stat = false, -- don't use inotify/kqueue but periodic check
		recursive = false -- watch dirs inside dirs
	}

	local event_cb = function(err, filename, events)
		callback()
	end

	vim.uv.fs_event_start(
		handle,
		path,
		flags,
		vim.schedule_wrap(event_cb)
	)

	return handle
end

-- File where tinty write the current scheme
local function tinty_path()
	return os.getenv("USER_TINTED_THEMING_DIR") .. "/current_scheme"
end

-- Return the content from a string or return some default content
local function read_file_or_default(filename, default)
	local file = io.open(filename, "r")
	if file then
		local content = file:read("*a")
		file:close()
		return content
	end
	return default
end

local function set_tinty_theme()
	vim.cmd("colorscheme " .. read_file_or_default(tinty_path()))
end

-- Set current theme
set_tinty_theme()
-- Change theme whenever tinty changes the theme
simple_on_file_change(tinty_path(), set_tinty_theme)


vim.cmd([[highlight EndOfBuffer ctermfg=bg guifg=bg]])
