if exists("g:project")
	let g:ale_enabled = 1
	let g:ale_completion_enabled = 1
	call dotfiles#project#load(g:project)
else
	let g:ale_enabled = 0
	let g:ale_completion_enabled = 0
	let g:ale_linters = {}
	let g:ale_fixers = {}
endif

command! ProjectEdit call dotfiles#project#edit(g:project)
