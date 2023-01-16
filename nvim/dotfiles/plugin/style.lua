-- Line numbers
vim.opt.number = true

-- Activate mouse
vim.opt.mouse = "a"

-- Hidden characters
vim.opt.list = true
vim.opt.listchars = {eol="¬", tab="──→", trail="·", nbsp="⌴", extends="…", precedes="…"}

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

vim.cmd([[highlight EndOfBuffer ctermfg=bg guifg=bg]])
