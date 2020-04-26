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

" Autoreload buffer when file has changed
set autoread
augroup auto_reload
	autocmd!
	autocmd FocusGained,BufEnter * :checktime
augroup end

" Authorize hidden buffer with modification
set hidden

" Set .bashrc as a bash extension
augroup bashrc_files
	autocmd!
	autocmd BufNewFile,BufRead *.bashrc setlocal filetype=sh
augroup end

" Colorcolumn relative to textwidth
set textwidth=90
set colorcolumn=+0

" Some Python specifics
augroup python_files
	autocmd!
	" Black default
	autocmd FileType python setlocal textwidth=88
augroup end

" Files to ignore
set wildignore+=*.DS_Store
set wildignore+=*.pyc,__pycache__,*.egg-info

" Command line completes common prefix on tab and open wildmenu. Tab again to cycle.
set wildmode=longest:full,full
" Change mapping in wildmenu to move with Up and Down.
" Cannot remap in wildmenu, but only command line, so we dynamically check.
" Also bind Right to open wildmenue on next folder when using paths.
" https://vi.stackexchange.com/a/22628
set wildcharm=<C-Z>  " Represent the completion character in macros
cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
cnoremap <expr> <right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"

" Completion mode
set completeopt=menuone,noinsert,noselect
set pumheight=5
