" Default encoding
set encoding=utf-8

" Default position for opening
set splitbelow
set splitright

" Format based on file type
filetype on
filetype indent on
filetype plugin on

" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" Remember window view for each buffer
augroup buffer_view
	autocmd!
	au BufLeave * let b:winview = winsaveview()
	au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
augroup end

" Tabs and spaces
set tabstop=2  " Width of tab character
set shiftwidth=2
set smarttab

" Autoreload buffer when file has changed
set autoread
augroup auto_reload
	autocmd!
	autocmd FocusGained,BufEnter * :checktime
augroup end

" Authorize hidden buffer with modification
set hidden

" Colorcolumn relative to textwidth
set textwidth=100
set colorcolumn=+0

" Files to ignore
set wildignore+=*.DS_Store
set wildignore+=*.pyc,__pycache__,*.egg-info

" Command line completes common prefix on tab and open wildmenu. Tab again to cycle.
set wildmode=longest:full,full

" Completion mode
set completeopt=menuone,noinsert,noselect  " Use longest ?
set pumheight=7