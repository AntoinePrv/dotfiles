" Resolve the ambiguous *.m and *.mm extensions to Objective-C rather than
" letting Neovim guess between Matlab, Octave, Mathematica, Murphi, and nroff
augroup objective_c_files
	autocmd!
	autocmd BufNewFile,BufRead *.m setlocal filetype=objc
	autocmd BufNewFile,BufRead *.mm setlocal filetype=objcpp
augroup end
