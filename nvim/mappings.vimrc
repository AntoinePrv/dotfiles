" General mappings
inoremap jk <Esc>

" Numbers
nnoremap <F3> :NumbersToggle<CR>
nnoremap <F4> :NumbersOnOff<CR>

" NERDTree
nnoremap <Leader>t :NERDTreeToggle<Enter>
nnoremap <silent> <Leader>f :NERDTreeFind<CR>

" ALE
" Navigate between errors
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
