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

" Functions for saving and restoring the buffer views.
"
" The logic takes care of some edge cases. See the origina article
" https://web.archive.org/web/20201025005002/https://vim.fandom.com/wiki/Avoid_scrolling_when_switch_buffers

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
	if !exists("w:SavedBufView")
		let w:SavedBufView = {}
	endif
	let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
	let buf = bufnr("%")
	if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
		let v = winsaveview()
		let atStartOfFile = v.lnum == 1 && v.col == 0
		if atStartOfFile && !&diff
			call winrestview(w:SavedBufView[buf])
		endif
		unlet w:SavedBufView[buf]
	endif
endfunction

" When switching buffers, preserve window view.
augroup buffer_view
	autocmd!
	autocmd BufLeave * call AutoSaveWinView()
	autocmd BufEnter * call AutoRestoreWinView()
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

" Never physically break lines
set textwidth=0 wrapmargin=0

" Files to ignore
set wildignore+=*.DS_Store
set wildignore+=*.pyc,__pycache__,*.egg-info

" Command line completes common prefix on tab and open wildmenu. Tab again to cycle.
set wildmode=longest:full,full

" Completion mode
set completeopt=menuone,noinsert,noselect  " Use longest ?
set pumheight=7
