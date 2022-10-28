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

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled=0
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#ale#enabled = 1
let g:airline_section_z = "%l/%L"
let g:airline_theme="base16_tomorrow"


lua << EOF

require('specs').setup{
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
		resizer = require('specs').shrink_resizer,
	},
}
vim.keymap.set(
	"n", "n", "n:lua require('specs').show_specs()<CR>",
	{silent=true, desc="Go to next search result"}
)
vim.keymap.set(
	"n", "N", "N:lua require('specs').show_specs()<CR>",
	{silent=true, desc="Go to previous search result"}
)

EOF
