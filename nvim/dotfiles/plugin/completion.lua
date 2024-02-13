------------------------
-- Setup for nvim-cmp --
------------------------

local cmp = require("cmp")

local cmp_icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "𝒙",
	Class = "ﴯ",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "&",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "ﴯ",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

local cmp_sources = {
	buffer = "[]",
	nvim_lsp = "[ﬦ]",
	nvim_lsp_signature_help = "[ﬦ]",
	luasnip = "[]",
	nvim_lua = "[]",
	latex_symbols = "[]",
	treesitter = "[]",
}

-- Check whether there are words before the cursor
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Call a given key in Nvim
local feed_key = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- Code completion in buffer
cmp.setup({
	snippet = {
		expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
	},
	completion = {
		autocomplete = false,
	},
	experimental = { ghost_text = true },
	mapping = {
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		-- Super-Tab like mapping
		["<Tab>"] = cmp.mapping(
			function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif vim.fn["vsnip#available"](1) == 1 then
					feedkey("<Plug>(vsnip-expand-or-jump)", "")
				elseif has_words_before() then
					cmp.complete()
				else
					fallback() -- The fallback function sends a already mapped key
				end
			end,
			{ "i", "s" }
		),
		["<S-Tab>"] = cmp.mapping(
			function()
				if cmp.visible() then
					cmp.select_prev_item()
				elseif vim.fn["vsnip#jumpable"](-1) == 1 then
					feedkey("<Plug>(vsnip-jump-prev)", "")
				end
			end,
			{ "i", "s" }
		),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			vim_item.kind = string.format("%s ", cmp_icons[vim_item.kind])
			vim_item.menu = cmp_sources[entry.source.name]
			return vim_item
		end
	},
	-- Only show buffer source when the first set is not available.
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
	}, {
		{ name = "treesitter" },
		{ name = "vsnip" },
		{ name = "path", option = { get_cwd = function(params) return vim.fn.getcwd() end } },
		{ name = "buffer" },
	}),
})

-- Completion for "/" search 
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" }
	}
})

-- Completion for ":" commands
cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" }
	}, {
		{ name = "cmdline" }
	})
})

-- Fetch lsp completion source
local cmp_nvim_lsp_capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())


-------------------------
-- Setup for lspconfig --
-------------------------

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Mappings.
	local opts = {noremap=true, silent=true, buffer=bufnr}

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>s", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set(
		"n",
		"<space>wl",
		function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
		bufopts
	)
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
	vim.keymap.set(
		"n",
		"[t",  -- memo: [tip
		function() vim.diagnostic.goto_prev({severity=vim.diagnostic.severity.HINT}) end,
		opts
	)
	vim.keymap.set(
		"n",
		"]t",  -- memo: ]tip
		function() vim.diagnostic.goto_next({severity=vim.diagnostic.severity.HINT}) end,
		opts
	)
	vim.keymap.set(
		"n",
		"[i",
		function() vim.diagnostic.goto_prev({severity=vim.diagnostic.severity.INFO}) end,
		opts
	)
	vim.keymap.set(
		"n",
		"]i",
		function() vim.diagnostic.goto_next({severity=vim.diagnostic.severity.INFO}) end,
		opts
	)
	vim.keymap.set(
		"n",
		"[w",
		function() vim.diagnostic.goto_prev({severity=vim.diagnostic.severity.WARN}) end,
		opts
	)
	vim.keymap.set(
		"n",
		"]w",
		function() vim.diagnostic.goto_next({severity=vim.diagnostic.severity.WARN}) end,
		opts
	)
	vim.keymap.set(
		"n",
		"[e",
		function() vim.diagnostic.goto_prev({severity=vim.diagnostic.severity.ERROR}) end,
		opts
	)
	vim.keymap.set(
		"n",
		"]e",
		function() vim.diagnostic.goto_next({severity=vim.diagnostic.severity.ERROR}) end,
		opts
	)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
	vim.keymap.set(
		"n",
		"<leader>f",
		function() vim.lsp.buf.format({async=true}) end,
		opts
	)
end

local nvim_lsp = require("lspconfig")

-- Map buffer local keybindings when the language server attaches.
-- :help lspconfig-server-configurations for LSP servers.
local servers = { "ruff_lsp", "pylsp",  "clangd" }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup {
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
	capabilities = cmp_nvim_lsp_capabilities
	}
end

nvim_lsp.rust_analyzer.setup({
	on_attach=on_attach,
})

-----------------------------
-- Configuring builtin LSP --
-----------------------------

-- TODO refactor to use same symbols table with lualine
local signs = {
	DiagnosticSignError = "",
	DiagnosticSignWarn = "",
	DiagnosticSignInfo = "",
	DiagnosticSignHint = "",
}
for name, symbol in pairs(signs) do
	vim.fn.sign_define(name, { texthl = name, text = symbol, numhl = "" })
end

vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	severity_sort = true
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 500
vim.api.nvim_create_autocmd(
	"CursorHold",
	{
		buffer = bufnr,
		callback = function()
			vim.diagnostic.open_float(
				nil,
				{
					focusable = false,
					close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
					source = 'always',
					prefix = ' ',
					scope = 'cursor',
				}
			)
		end
	}
)

-- Weirdly complicated for setting the highlight for diagnostic.
vim.cmd([[
function! s:underline_highlight(group, color)
	let l:command = "highlight! " . a:group
	let l:command = l:command . " guisp=" . a:color . " gui=undercurl guifg=NONE guibg=NONE"
	let l:command = l:command . " ctermfg=NONE ctermbg=NONE term=underline cterm=undercurl"
	execute l:command
endfunction

function! s:diagnostic_highlight()
	call s:underline_highlight("DiagnosticUnderlineError", "red")
	call s:underline_highlight("DiagnosticUnderlineWarn", "yellow")
endfunction

augroup diagnostic_highlight
	autocmd!
	autocmd ColorScheme * call s:diagnostic_highlight()
augroup end

call s:diagnostic_highlight()
]])

