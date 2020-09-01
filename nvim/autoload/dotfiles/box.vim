" Return the character under the cursor
" https://stackoverflow.com/questions/23323747/vim-vimscript-get-exact-character-under-the-cursor
function! s:CursorChar()
	return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfunction

" Resize a box horizontally if the middle text has changed
function! dotfiles#box#re_box()
	" Read character at begining of line (accounting for indent)
	:execute "normal! ^"
	let l:char = s:CursorChar()
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
function! dotfiles#box#box(char)
	" Add symbols at begining and end of line (accounting for indent)
	:execute "normal! I" . a:char . "  "
	:execute "normal! A  " . a:char
	" Create line above and below
	:execute "normal! yy2Pj"
	" Restore Box
	:call dotfiles#box#re_box()
endfunction

" Create a box for C++ style comment, with star and a leading/terminating slash
function! dotfiles#box#c_box()
	:call dotfiles#box#box('*')
	:execute "normal! I "
	:execute "normal! kI/"
	:execute "normal! 2jI \<esc>A/"
	:execute "normal! k"
endfunction

function! dotfiles#box#c_re_box()
	:call dotfiles#box#re_box()
	:execute "normal! k^hr/"
	:execute "normal! 2jA/"
	:execute "normal! k"
endfunction
