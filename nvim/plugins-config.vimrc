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
" Ignore files from wildignore
let NERDTreeRespectWildIgnore=1


" NERDTree
augroup nerd_tree
	autocmd!
	" Auto open NERDTree
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
augroup end
" Auto delete buffer of deleted file
let NERDTreeAutoDeleteBuffer = 1


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


" ale
let g:ale_sign_error = 'ﱥ'
let g:ale_sign_warning = ''
let g:ale_completion_enabled = 1
let g:ale_linters = {'python': ['pyls', 'pydocstyle']}
let g:ale_fixers = {
	\'*': ['remove_trailing_lines', 'trim_whitespace'],
	\'python': ['black'],
\}
let g:ale_fix_on_save = 1


" Tmuxline
function! TmuxvarResolve_var(name)
	let command = a:name.'=$(tmux showenv __TMUX#{pane_id}_'.a:name.') && '
	let command = command . a:name.'=\\${'.a:name.'#__TMUX#{pane_id}_'.a:name.'=}'
	let command = command . ' && '
	return command
endfunction

function! TmuxvarPwd()
	let command = ' #('.TmuxvarResolve_var('PWD')
	let command = command . 'cd \\$PWD && pwd | xargs basename)'
	return command
endfunction

function! TmuxvarGit_branch()
	let command = '#('.TmuxvarResolve_var('PWD').'cd \\$PWD && '
	let command = command . '(git rev-parse --abbrev-ref HEAD && echo "") '
	let command = command . '| sed ''1!G;h;$!d''  | paste -sd " " -)'
	return command
endfunction

function! TmuxvarVirtualenv()
	let command = '#('.TmuxvarResolve_var('VIRTUAL_ENV')
	let command = command . 'echo " $(basename \\$VIRTUAL_ENV)")'
	return command
endfunction

let g:tmuxline_preset = {
	\'a'    : '%a %R',
	\'b'    : '#h',
	\'c'    : ' #S',
	\'cwin' : '#I:#W#F',
	\'win'  : '#I:#W',
	\'x'    : TmuxvarGit_branch(),
	\'y'    : TmuxvarPwd(),
	\'z'    : TmuxvarVirtualenv(),
	\'options' : {'status-justify': 'left'}
\}

" Promptline
" Small prompt for inside tmux
" Read the color from an airline extension. Also
let g:promptline_theme = 'airline_insert'
let g:promptline_preset = {
	\'a'    : [ '\W' ],
	\'x'    : [ promptline#slices#jobs() ],
	\'warn' : [ promptline#slices#last_exit_code() ]
\}
" Full prompt for inside tmux
let g:promptline_preset = {
	\'a'    : [ promptline#slices#host({ 'only_if_ssh': 1 }), '\W'],
	\'b'    : [ promptline#slices#vcs_branch(), promptline#slices#git_status() ],
	\'c'    : [ promptline#slices#python_virtualenv() ],
	\'x'    : [ promptline#slices#jobs() ],
	\'warn' : [ promptline#slices#last_exit_code() ]
\}
