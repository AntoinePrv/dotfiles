" NerdCommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align comment delimiters flush left instead of code indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1


" Procession
let g:prosession_dir = stdpath("data") . "/prosession"

" Base16 colors
colorscheme base16-default-dark
" Use the 256 color space to avoid redifining bright colors
let base16colorspace=256
" Cutomize Base16 theme
function! s:base16_customize() abort
	" Colors: https://github.com/chriskempson/base16/blob/master/styling.md
	" Arguments: group, guifg, guibg, ctermfg, ctermbg, attr, guisp
	" Remove background highlight present by default in vi
	call Base16hi("SpellBad",   "None", "None", "None", "None", "underline,italic")
	call Base16hi("SpellCap",   "None", "None", "None", "None", "underline,italic")
	call Base16hi("SpellLocal", "None", "None", "None", "None", "underline,italic")
	call Base16hi("SpellRare",  "None", "None", "None", "None", "underline,italic")
	" Set Ale signs
	let l:signcol_bg = synIDattr(hlID('SignColumn'),'bg')
	call Base16hi("ALEErrorSign", g:base16_gui08, l:signcol_bg, g:base16_cterm08, l:signcol_bg)
	call Base16hi("ALEWarningSign", g:base16_gui0A, l:signcol_bg, g:base16_cterm0A, l:signcol_bg)
endfunction
augroup on_change_colorschema
	autocmd!
	autocmd ColorScheme * call s:base16_customize()
augroup end


" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled=0
let g:airline#extensions#tmuxline#enabled = 0
let g:airline_section_z = '%l/%L'
let g:airline_theme='base16_tomorrow'


" git-gutter
set updatetime=100
" When signs don't update after focusing Vim. Your terminal probably isn't
" reporting focus events. Either try installing Terminus or set:
let g:gitgutter_terminal_reports_focus=0

" vim-devicons
" Use folder icons
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
" Enable open and close folder/directory glyph flags
let g:DevIconsEnableFoldersOpenClose = 1
" Change the default character when no match found
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = ''
" Extra symbols
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols['Pipfile.lock'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols['Pipfile'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['toml'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['json'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['yaml'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['yml'] = ''

" Fzf
function FzfFindFile()
	" Change sources if in git
	call system('git rev-parse --is-inside-work-tree')
	if v:shell_error == 0
		let fzf_config = {
			\ 'source': 'git ls-files --exclude-standard  -oc -z',
			\ 'options': '--read0 --reverse --info=hidden --prompt=" "'
		\}
	else
		let fzf_config = {}
	endif
	call fzf#run(fzf#wrap(fzf_config))
endfunction
let g:fzf_layout = {
	\ 'window': {
		\ 'width': 0.5,
		\ 'height': 0.3,
		\ 'border': 'sharp',
		\ 'style': 'minimal',
	\}
\}

" ale
let g:ale_sign_error = 'ﱥ'
let g:ale_sign_warning = ''
let g:ale_completion_symbols = {
	\ 'text': '',
	\ 'method': '',
	\ 'function': 'λ',
	\ 'constructor': '',
	\ 'field': '',
	\ 'variable': 'x',
	\ 'class': '',
	\ 'interface': '',
	\ 'module': '',
	\ 'property': '',
	\ 'unit': '',
	\ 'value': 'val',
	\ 'enum': '',
	\ 'keyword': '',
	\ 'snippet': '',
	\ 'color': '',
	\ 'file': '',
	\ 'reference': '&',
	\ 'folder': '',
	\ 'enum member': '',
	\ 'constant': '',
	\ 'struct': '',
	\ 'event': '',
	\ 'operator': '+',
	\ 'type_parameter': 'type param',
	\ '<default>': '?'
	\ }
let g:ale_completion_enabled = 1
let g:ale_linters = {
	\'python': ['pyls', 'pydocstyle'],
	\'cpp': ['clangd', 'clangtidy'],
\}
let g:ale_fixers = {
	\'*': ['remove_trailing_lines', 'trim_whitespace'],
	\'python': ['black'],
	\'cpp': ['clangtidy', 'clang-format'],
\}
let g:ale_fix_on_save = 1

" Float-preview (replacement for completopt+=preview using flaoting window)
let g:float_preview#docked = 0
