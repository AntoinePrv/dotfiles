" Default encoding
set encoding=utf-8

" Default position for opening
set splitbelow
set splitright

" Format based on file type
filetype on
filetype indent on
filetype plugin on

" Remember window view for each buffer
augroup buffer_view
	autocmd!
	au BufLeave * let b:winview = winsaveview()
	au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
augroup end

" Set .bashrc as a bash extension
augroup bashrc_files
	autocmd!
	autocmd BufNewFile,BufRead *.bashrc setlocal filetype=sh
augroup end

" Colorcolumn relative to textwidth
set textwidth=80
set colorcolumn=+0

" Some Python specifics
augroup python_files
	autocmd!
	autocmd FileType python setlocal textwidth=80
augroup end

" Files to ignore
set wildignore+=*.DS_Store
set wildignore+=*.pyc,__pycache__,*.egg-info

" Completion mode
set completeopt=menuone,preview,noinsert
