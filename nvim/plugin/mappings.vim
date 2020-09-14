" Use space as leader but allow it to display properly with \
let mapleader = "\\"
nmap <space> <leader>
vmap <space> <leader>

" General mappings
inoremap jk <Esc>
nnoremap <silent> <C-W>_ :split<CR>
nnoremap <silent> <C-W><Bar> :vsplit<CR>

" Numbers
nnoremap <F3> :NumbersToggle<CR>
nnoremap <F4> :NumbersOnOff<CR>

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
