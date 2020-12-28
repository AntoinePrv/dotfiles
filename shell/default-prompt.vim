" Bash only prompt generated through vim Promptline
" This setting is for the default/regular prompt
" After sourcing this file, run `:PromptlineSnapshot [file]`

" Read the colors from airline extension
let g:promptline_theme = 'airline_insert'

let g:promptline_preset = {
	\'a'    : [ promptline#slices#host({ 'only_if_ssh': 1 }), '\W'],
	\'b'    : [ promptline#slices#vcs_branch(), promptline#slices#git_status() ],
	\'c'    : [ promptline#slices#python_virtualenv() ],
	\'x'    : [ promptline#slices#jobs() ],
	\'warn' : [ promptline#slices#last_exit_code() ]
\}
