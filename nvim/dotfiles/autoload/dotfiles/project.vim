" Inclusion guard
if exists("g:project_loaded")
	finish
endif
let g:project_loaded = 1


let s:projects_dir = stdpath("data") . "/projects"

function! s:current_project_dir(project_name)
	return fnamemodify(s:projects_dir . "/" . a:project_name, ":p")
endfunction

function! s:current_session_file(project_name)
	return s:current_project_dir(a:project_name) . "/Session.vim"
endfunction

function! s:current_init_file(project_name)
	return s:current_project_dir(a:project_name) . "/init.vim"
endfunction

function! s:maybe_mkdir(dir)
	silent execute "!mkdir -p " . a:dir
endfunction

function! s:source(file)
	silent execute "source " . a:file
endfunction

function! s:load_or_make_session(project_name)
	let l:session_file = s:current_session_file(a:project_name)
	if filereadable(l:session_file)
		call s:source(l:session_file)
	else
		execute ":Obsession " . l:session_file
	endif
endfunction

function! s:lazy_load_or_make_session(project_name)
	if v:vim_did_enter
		silent call s:load_or_make_session(a:project_name)
	else
		let s:project_name = a:project_name  " Needed to capture the variable in the autocommand
		autocmd VimEnter * nested silent call s:load_or_make_session(s:project_name)
	endif
endfunction

function! s:load_or_make_init(project_name)
	let l:init_file = s:current_init_file(a:project_name)
	if !filereadable(l:init_file)
		call writefile(["\" Commands sourced for the project " . a:project_name], l:init_file)
	endif
	call s:source(l:init_file)
endfunction


function! dotfiles#project#load(project_name)
	call s:maybe_mkdir(s:current_project_dir(a:project_name))
	call s:load_or_make_init(a:project_name)
	call s:lazy_load_or_make_session(a:project_name)
endfunction

function! dotfiles#project#edit(project_name)
	execute "edit " . s:current_init_file(a:project_name)
endfunction

