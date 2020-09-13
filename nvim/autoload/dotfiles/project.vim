" Inclusion guard
if exists("g:project_loaded")
	finish
endif
let g:project_loaded = 1


let s:projects_dir = stdpath("data") . "/projects"

function! s:current_project_name()
	return sha256(simplify(fnamemodify(g:project_file, ":p")))
endfunction

function! s:current_project_dir()
	return fnamemodify(s:projects_dir . "/" . s:current_project_name(), ":p")
endfunction

function! s:current_session_file()
	return s:current_project_dir() . "/Session.vim"
endfunction

function! s:maybe_mkdir(dir)
	silent execute "!mkdir -p " . a:dir
endfunction

function! s:source(file)
	silent execute "source " . a:file
endfunction

function! s:load_or_make_session(session_file)
	if filereadable(a:session_file)
		call s:source(a:session_file)
	else
		execute ":Obsession " . a:session_file
	endif
endfunction

function! s:init_session()
	call s:maybe_mkdir(s:current_project_dir())
	autocmd VimEnter * nested silent call s:load_or_make_session(s:current_session_file())
endfunction

function! dotfiles#project#load()
	call s:source(g:project_file)
	call s:init_session()
endfunction
