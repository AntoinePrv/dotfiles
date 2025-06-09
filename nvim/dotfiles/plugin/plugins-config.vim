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

let g:scrolloff_absolute_filetypes = ["qf", "specs.nvim"]

lua << EOF

require("nvim-autopairs").setup()

require("nvim-ts-autotag").setup()

require("hlsearch").setup()

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
			sign={ namespace = { "diagnostic" }, colwidth=2, wrap=false, auto=false },
			condition={ true },
			click="v:lua.ScSa" -- Status Col Sign Action
		},
		{
			sign={ name = { ".*" }, maxwidth=2, colwidth=1, auto=true, wrap=false },
			click="v:lua.ScSa" -- Status Col Sign Action
		},
	}
})


require("render-markdown").setup({
    file_types = { "markdown", "codecompanion" },
})

-- Only needed to authenticate copilot, needs nodejs
-- Maybe vendor :Copilot auth
-- require("copilot").setup({
--     panel = { enabled = false },
--     suggestion = { enabled = false },
-- })

require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "copilot",
       keymaps = {
        send = {
          modes = { n = "<CR>" },
          opts = {},
        },
        close = {
          modes = { n = "<ESC>"},
          opts = {},
        },
       },
    },
    inline = {
      adapter = "copilot",
    },
    cmd = {
      adapter = "copilot",
    }
  },
  display = {
    action_palette = {
      width = 95,
      height = 10,
      provider = "telescope",
      opts = {
        show_default_actions = true,
        show_default_prompt_library = true,
      },
    },
    chat = {
	show_header_separator = true,
    },
  },
})

EOF
