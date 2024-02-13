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

local colors_ansi = {
  black=0,  -- background, is white in light-mode
  red=1,
  green=2,
  yellow=3,
  blue=4,
  magenta=5,
  cyan=6,
  white=7,  -- foreground, is black in dark-mode
}

local colors_base16_cterm = {
  base00=tonumber(vim.g.base16_cterm00),  -- base16 shell ANSI: 00
  base01=tonumber(vim.g.base16_cterm01),  -- base16 shell ANSI: 18
  base02=tonumber(vim.g.base16_cterm02),  -- base16 shell ANSI: 19
  base03=tonumber(vim.g.base16_cterm03),  -- base16 shell ANSI: 08
  base04=tonumber(vim.g.base16_cterm04),  -- base16 shell ANSI: 20
  base05=tonumber(vim.g.base16_cterm05),  -- base16 shell ANSI: 07
  base06=tonumber(vim.g.base16_cterm06),  -- base16 shell ANSI: 21
  base07=tonumber(vim.g.base16_cterm07),  -- base16 shell ANSI: 15
  base08=tonumber(vim.g.base16_cterm08),  -- base16 shell ANSI: 01
  base09=tonumber(vim.g.base16_cterm09),  -- base16 shell ANSI: 16
  base0A=tonumber(vim.g.base16_cterm0A),  -- base16 shell ANSI: 03
  base0B=tonumber(vim.g.base16_cterm0B),  -- base16 shell ANSI: 02
  base0C=tonumber(vim.g.base16_cterm0C),  -- base16 shell ANSI: 06
  base0D=tonumber(vim.g.base16_cterm0D),  -- base16 shell ANSI: 04
  base0E=tonumber(vim.g.base16_cterm0E),  -- base16 shell ANSI: 05
  base0F=tonumber(vim.g.base16_cterm0F),  -- base16 shell ANSI: 17
}

local theme={
  normal={
    a={bg=colors_base16_cterm.base0D, fg=colors_base16_cterm.base06, gui="bold"},
    b={bg=colors_base16_cterm.base07, fg=colors_base16_cterm.base00},
    c={bg=colors_base16_cterm.base02, fg=colors_base16_cterm.base06},
  },
  insert={
    a={bg=colors_base16_cterm.base0B, fg=colors_base16_cterm.base06, gui="bold"},
  },
  visual={
    a={bg=colors_base16_cterm.base0E, fg=colors_base16_cterm.base06, gui="bold"},
  },
  replace={
    a={bg=colors_base16_cterm.base08, fg=colors_base16_cterm.base06, gui="bold"},
  },
  command={
    a={bg=colors_base16_cterm.base03, fg=colors_base16_cterm.base06, gui="bold"},
  },
  inactive={
    a={bg=colors_base16_cterm.base03, fg=colors_base16_cterm.base06, gui="bold"},
    b={bg=colors_base16_cterm.base02, fg=colors_base16_cterm.base06},
    c={bg=colors_base16_cterm.base01, fg=colors_base16_cterm.base06},
  }
}
 
local symbols = {
   file_modified="",
   file_readonly="",
   file_unnamed="[...]",
   file_newfile="",
   error=" ",
   warning=" ",
   info=" ",
   hint=" " 
}

local lualine_sections = {
  lualine_a={},
  lualine_b={
    {
      "filename",
      path=1,
      symbols={
        modified=symbols.file_modified,
        readonly=symbols.file_readonly,
        unnamed=symbols.file_unnamed,
        newfile=symbols.file_newfile,
      },
    },
    {
      "diff",
      diff_color={
        added={fg=colors_ansi.green},
        modified={fg=colors_ansi.magenta},
        removed={fg=colors_ansi.red},
      },
    }
  },
  lualine_c={"encoding", "fileformat", "filetype"},
  lualine_x={},
  lualine_y={{
    "diagnostics",
    sections={"error", "warn"},
    symbols={
      error=symbols.error,
      warn=symbols.warning,
      info=symbols.info,
      hint=symbols.hint,
    },
    diagnostics_color = {
      error={fg=colors_ansi.red},
      warn={fg=colors_ansi.yellow},
      info={fg=colors_ansi.blue},
      hint={fg=colors_ansi.cyan},
    },
    colored=true,
    update_in_insert=false,
    always_visible=false,
  }},
  lualine_z={"location", "progress", "searchcount"}
}

require("lualine").setup {
  options={
    icons_enabled=true,
    theme=theme,
    component_separators={ left="", right="" },
    section_separators={ left="", right=""},
  },
  sections=lualine_sections,
  inactive_sections=lualine_sections,
  tabline={
    lualine_b={{
      "tabs",
      mode=1,
      symbols={modified=symbols.file_modified},
    }},
    lualine_z={"mode"},
  },
  winbar=lualine_winbar,
  inactive_winbar=lualine_winbar,
  extensions={}
}

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
		-- Somehow scrolloff seems to be reset so we set it again
		vim.cmd("call ScrollOffFraction(g:scrolloff_fraction)")
	end,
	{silent=true, desc="Go to next search result"}
)
vim.keymap.set(
	"n",
	"N",
	function()
		vim.cmd("silent! normal! N")
		specs.show_specs()
		-- Somehow scrolloff seems to be reset so we set it again
		vim.cmd("call ScrollOffFraction(g:scrolloff_fraction)")
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
