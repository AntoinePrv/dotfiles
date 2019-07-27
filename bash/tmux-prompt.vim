" Bash only prompt generated through vim Promptline
" This setting is for the prompt inside tmux
" After sourcing this file, run `:PromptlineSnapshot [file]`

" Read the colors from airline extension
let g:promptline_theme = 'airline_insert'

let g:promptline_preset = {
	\'a'    : [ '\W' ],
	\'x'    : [ promptline#slices#jobs() ],
	\'warn' : [ promptline#slices#last_exit_code() ]
\}
