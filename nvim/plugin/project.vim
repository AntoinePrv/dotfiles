if exists("g:project_file")
	let g:ale_enabled = 1
	let g:ale_completion_enabled = 1
	call dotfiles#project#load()
else
	let g:ale_enabled = 0
	let g:ale_completion_enabled = 0
	let g:ale_linters = {}
	let g:ale_fixers = {}
endif
