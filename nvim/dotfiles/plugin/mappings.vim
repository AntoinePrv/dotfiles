" Use space as leader but allow it to display properly with \
let mapleader = "\\"
nmap <space> <leader>
vmap <space> <leader>

" General mappings
inoremap jk <Esc>
nnoremap <silent> <C-W>_ :split<CR>
nnoremap <silent> <C-W><Bar> :vsplit<CR>
" More intuitive default from `:help cw`
noremap cw dwi
noremap cW dWi

" Nerd Commenter
nnoremap <silent> <leader>/ :call nerdcommenter#Comment(0, "toggle")<CR>
vnoremap <silent> <leader>/ :call nerdcommenter#Comment(0, "toggle")<CR>

" Netwr
nnoremap <leader>e :Explore<CR>

" Fzf
nnoremap <leader>p :call FzfFindFile()<CR>
