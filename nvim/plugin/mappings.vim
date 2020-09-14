" Use space as leader but allow it to display properly with \
let mapleader = "\\"
nmap <space> <leader>
vmap <space> <leader>

" General mappings
inoremap jk <Esc>
nnoremap <silent> <C-W>_ :split<CR>
nnoremap <silent> <C-W><Bar> :vsplit<CR>

" Tab complete or indent
function! InsertTabWrapper()
	if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
		" return tab if empry line
		return "\<tab>"
	endif
	if pumvisible()
		" Next completion if completion menue is open
		return "\<down>"
	endif
	" Open omni completion
	return "\<C-X>\<C-O>"
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" Change mapping in wildmenu to move with Up and Down.
" Cannot remap in wildmenu, but only command line, so we dynamically check.
" Also bind Right to open wildmenue on next folder when using paths.
" https://vi.stackexchange.com/a/22628
set wildcharm=<C-Z>  " Represent the completion character in macros
cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
cnoremap <expr> <right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"

" Nerd Commenter
nnoremap <silent> <leader>/ :call NERDComment(0, "toggle")<CR>
vnoremap <silent> <leader>/ :call NERDComment(0, "toggle")<CR>

" Netwr
nnoremap <leader>e :Explore<CR>

" Fzf
nnoremap <leader>p :call FzfFindFile()<CR>

" ALE Go to definition
nnoremap <leader>g :ALEGoToDefinition<CR>
nnoremap <leader>h :ALEHover<CR>
nnoremap <leader>r :ALERename<CR>

" ALE Navigate between errors
nmap <silent> ]e :call AleNextError()<CR>
function! AleNextError() range
	for l:i in range(v:count1)
		:execute "normal \<Plug>(ale_next_wrap)"
	endfor
endfunction

nmap <silent> [e :call AlePreviousError()<CR>
function! AlePreviousError() range
	for l:i in range(v:count1)
		:execute "normal \<Plug>(ale_previous_wrap)"
	endfor
endfunction
