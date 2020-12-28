" Zsh only prompt generated through vim Promptline
" This setting is for the prompt inside tmux
" After sourcing this file, run `:PromptlineSnapshot [file]`

" Read the colors from airline extension
let g:promptline_theme = "airline_insert"

let g:promptline_preset = {
	\"a"    : [promptline#slices#cwd({"dir_limit":2})],
	\"z"    : [promptline#slices#jobs()],
	\"warn" : [promptline#slices#last_exit_code()],
	\"options": {
		\"left_sections" : ["a", "warn"],
		\"right_sections" : ["z"],
		\"left_only_sections" : ["a", "z", "warn"]
	\ }
\}
