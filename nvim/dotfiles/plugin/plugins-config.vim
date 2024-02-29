" NerdCommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align comment delimiters flush left instead of code indentation
let g:NERDDefaultAlign = "left"
" Allow commenting and inverting empty lines
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1


" Base16 colors
let base16colorspace=256
colorscheme base16-default-dark


lua << EOF

require("nvim-autopairs").setup()

require("ibl").setup {
	indent={
		char="│"
	},
	scope={
		char="┃",
		show_start=false,
		show_end=false,
	highlight={"Identifier"},
	},
}

require("virt-column").setup({
	char="┋"
})

local specs = require("specs")
specs.setup{
	show_jumps  = true,
	min_jump = 10,
	popup = {
		-- Delay before popup displays
		delay_ms = 50,
		-- Time increments used for fade/resize effects
		inc_ms = 20,
		-- starting blend, between 0-100 (fully transparent), see :h winblend
		blend = 100,
		width = 10,
		winhl = "Search",
		fader = nil,
		resizer = specs.shrink_resizer,
	},
}
vim.keymap.set(
	"n",
	"n",
	function()
		vim.cmd("silent! normal! n")
		specs.show_specs()
	end,
	{silent=true, desc="Go to next search result"}
)
vim.keymap.set(
	"n",
	"N",
	function()
		vim.cmd("silent! normal! N")
		specs.show_specs()
	end,
	{silent=true, desc="Go to previous search result"}
)


local statuscol_builtin = require("statuscol.builtin")

require("statuscol").setup({
	ft_ignore={
		"lspinfo",
		"packer",
		"checkhealth",
		"help",
		"man",
		"TelescopePrompt",
		"TelescopeResults",
	},
	segments = {
		-- {
		--   text={ statuscol_builtin.foldfunc },
		--   click="v:lua.ScFa"  -- Status Col Fold Action
		-- },
		{
			sign={ namespace={ "gitsign" }, colwidth=1, wrap=true, auto=false, fillchar = " ",},
			click="v:lua.ScSa",  -- Status Col Sign Action
			condition={ true },
		},
		{
			text={ statuscol_builtin.lnumfunc },
			click="v:lua.ScLa",  -- Status Col Number/Line Action
		},
		{
			sign={ name={ "Diagnostic" }, colwidth=2, wrap=false, auto=false },
			condition={ true },
			click="v:lua.ScSa" -- Status Col Sign Action
		},
		{
			sign={ name = { ".*" }, maxwidth=2, colwidth=1, auto=true, wrap=false },
			click="v:lua.ScSa" -- Status Col Sign Action
		},
	}
})

EOF
