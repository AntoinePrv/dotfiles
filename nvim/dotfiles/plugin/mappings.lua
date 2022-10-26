-- Various remaping.
-- Inspiration from https://github.com/ibhagwan/nvim-lua/blob/main/lua/keymaps.lua

-- Use space as leader but allow it to display properly with \
vim.g.mapleader = "\\"
vim.keymap.set({"n", "v"}, "<space>", "<leader>", {remap=true})

-- General
vim.keymap.set("i", "jk", "<Esc>", {desc="Exit inster mode"})
vim.keymap.set("n", "<C-S>", ":wa<CR>", {silent=true, desc="Save all buffers"})

-- Navigation
vim.keymap.set({"n", "v", "o"}, "K", "gg", {desc="Go to top of buffer"})
vim.keymap.set({"n", "v", "o"}, "J", "G", {desc="Go to bottom of buffer"})
vim.keymap.set({"n", "v", "o"}, "H", "^", {desc="Go to begining of line"})
vim.keymap.set({"n", "v", "o"}, "L", "$", {desc="Go to end of line"})

-- Remaps
vim.keymap.set({"n", "v"}, "<leader>j", "J", {desc="Join lines"})
vim.keymap.set({"n", "v"}, "<leader>u", "gu", {desc="Change text to lowercase"})
vim.keymap.set({"n", "v"}, "<leader>U", "gU", {desc="Change text to uppercase"})

-- Windows
vim.keymap.set("n", "<C-W>-", ":split<CR>", {silent=true})
vim.keymap.set("n", "<C-W><Bslash>", ":vsplit<CR>", {silent=true})

-- More intuitive default from `:help cw`
vim.keymap.set("n", "cw", "dwi")
vim.keymap.set("n", "cW", "dWi")

-- Call a function n times
local function call_n(n, func, ...)
	for i = 1, n do
		func(...)
	end
end

-- Make a function repeat the number of times provided by vim.v.count for mappings
local function repeatable(func, ...)
	-- local args = table.pack(...)  -- More appropriate but unavailable in current lua version
	local args = {...}
	return function ()
		if (vim.v.count > 0) then
			call_n(vim.v.count, func, unpack(args))
		else
			call_n(1, func, unpack(args))
		end
	end
end

-- Navigate buffers
vim.keymap.set("n", "[b", repeatable(vim.cmd, ":bprevious"), {silent=true})
vim.keymap.set("n", "]b", repeatable(vim.cmd, ":bnext"), {silent=true})
vim.keymap.set("n", "[B", repeatable(vim.cmd, ":bfirst"), {silent=true})
vim.keymap.set("n", "]B", repeatable(vim.cmd, ":blast"), {silent=true})
-- Quickfix list mappings
vim.keymap.set("n", "[q", repeatable(vim.cmd, ":cprevious"))
vim.keymap.set("n", "]q", repeatable(vim.cmd, ":cnext"))
vim.keymap.set("n", "[Q", repeatable(vim.cmd, ":cfirst"))
vim.keymap.set("n", "]Q", repeatable(vim.cmd, ":clast"))
-- Location list mappings
vim.keymap.set("n", "[l", repeatable(vim.cmd, ":lprevious"))
vim.keymap.set("n", "]l", repeatable(vim.cmd, ":lnext"))
vim.keymap.set("n", "[L", repeatable(vim.cmd, ":lfirst"))
vim.keymap.set("n", "]L", repeatable(vim.cmd, ":llast"))

-- Move selected lines up/down in visual mode

-- Nerd Commenter
vim.keymap.set({"n", "v"}, "<leader>/", ":call nerdcommenter#Comment(0, 'toggle')<CR>")

-- Netwr
vim.keymap.set("n", "<leader>e", ":Explore<CR>")

-- Fzf
vim.keymap.set("n", "<leader>p", vim.fn.FzfFindFile)

