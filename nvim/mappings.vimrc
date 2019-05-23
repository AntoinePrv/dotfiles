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
nmap <silent> [e <Plug>(ale_previous_wrap)
nmap <silent> ]e <Plug>(ale_next_wrap)
