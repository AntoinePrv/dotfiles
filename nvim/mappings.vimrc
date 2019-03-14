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
nmap <silent> <leader>e <Plug>(ale_previous_wrap)
nmap <silent> <leader>E <Plug>(ale_next_wrap)
