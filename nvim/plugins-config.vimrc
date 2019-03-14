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


" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled=0
let g:airline_section_z = '%l/%L'


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
let g:ale_sign_warning = ''
let g:ale_completion_enabled = 1
let g:ale_linters = {'python': ['pyls', 'pydocstyle']}
let g:ale_fixers = {
	\'*': ['remove_trailing_lines', 'trim_whitespace'],
	\'python': ['autopep8'],
\}
let g:ale_fix_on_save = 1


" Tmuxline
let g:tmuxline_preset = {
	\'a'    : ['#h', ' #S'],
	\'cwin' : '#I:#W#F',
	\'win'  : '#I:#W',
	\'x'    : '#(cd #{pane_current_path}; (git rev-parse --abbrev-ref HEAD && echo "") | tail -r | paste -sd " " -)',
	\'y'    : ' #(cd #{pane_current_path}; pwd | xargs basename)',
	\'z'    : '%R %a',
	\'options' : {'status-justify': 'left'}
\}


" Promptline
" Small prompt for inside tmux
let g:promptline_preset = {
	\'a'    : [ '\W' ],
	\'b'    : [ promptline#slices#jobs() ],
	\'warn' : [ promptline#slices#last_exit_code() ]
\}
" Full prompt putide tmux
let g:promptline_preset = {
	\'a'    : [ promptline#slices#host({ 'only_if_ssh': 1 }), '\W'],
	\'b'    : [ promptline#slices#vcs_branch(), promptline#slices#git_status() ],
	\'c'    : [ promptline#slices#python_virtualenv() ],
	\'x'    : [ promptline#slices#jobs() ],
	\'warn' : [ promptline#slices#last_exit_code() ]
\}
