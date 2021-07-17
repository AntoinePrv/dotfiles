" Set .bashrc as a bash extension
augroup bashrc_files
	autocmd!
	autocmd BufNewFile,BufRead *.bashrc setlocal filetype=sh
augroup end
