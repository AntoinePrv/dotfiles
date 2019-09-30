" Use space as leader but allow it to display properly wiht \
let mapleader = "\\"
nmap <space> <Leader>

" General mappings
inoremap jk <Esc>
nnoremap <silent> <C-W>_ :split<CR>
nnoremap <silent> <C-W><Bar> :vsplit<CR>

" Numbers
nnoremap <F3> :NumbersToggle<CR>
nnoremap <F4> :NumbersOnOff<CR>

" Netwr
nnoremap <leader>e :Explore<CR>

" ALE Go to definition
nnoremap <Leader>g :ALEGoToDefinition<CR>

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
