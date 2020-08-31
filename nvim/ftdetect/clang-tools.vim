" Set clang-tidy clang-format as a yaml file type
augroup clang_files
	autocmd!
	autocmd BufNewFile,BufRead .clang-tidy setlocal filetype=yaml
	autocmd BufNewFile,BufRead .clang-format setlocal filetype=yaml
augroup end
