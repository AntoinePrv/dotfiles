" Use space as leader but allow it to display properly wiht \
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

" Return the character under the cursor
" https://stackoverflow.com/questions/23323747/vim-vimscript-get-exact-character-under-the-cursor
function! CursorChar()
	return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfunction

" Resize a box horizontally if the middle text has changed
function! ReBox()
	" Read character at begining of line (accounting for indent)
	:execute "normal! ^"
	let l:char = CursorChar()
	" Replace line above with middle one
	:execute "normal! yyk"
	:execute "normal! V\"0p"
	" Replace line with character (accounting for indent)
	:execute "normal! ^v$r" . l:char
	" Replace line below with middle one
	:execute "normal! 2j"
	:execute "normal! V\"0p"
	" Replace line with character (accounting for indent)
	:execute "normal! ^v$r" . l:char
	:execute "normal! k"
endfunction

" Create A box around the text in the line with the given character
function! Box(char)
	" Add symbols at begining and end of line (accounting for indent)
	:execute "normal! I" . a:char . "  "
	:execute "normal! A  " . a:char
	" Create line above and below
	:execute "normal! yy2Pj"
	" Restore Box
	:call ReBox()
endfunction

" Create a box for C++ style comment, with star and a leading/terminating slash
function! CBox()
	:call Box('*')
	:execute "normal! I "
	:execute "normal! kI/"
	:execute "normal! 2jI \<esc>A/"
	:execute "normal! k"
endfunction

function! CReBox()
	:call ReBox()
	:execute "normal! k^hr/"
	:execute "normal! 2jA/"
	:execute "normal! k"
endfunction

augroup box
	autocmd!
	autocmd FileType python nnoremap<buffer> <Leader>b :call Box('#')<CR>
	autocmd FileType cpp nnoremap<buffer> <Leader>b :call CBox()<CR>
augroup end
