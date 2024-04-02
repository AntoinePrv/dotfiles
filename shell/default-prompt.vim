" Zsh only prompt generated through vim Promptline
" This setting is for the default/regular prompt
" After sourcing this file, run `:PromptlineSnapshot [file]`
" Plugin use("edkolev/promptline.vim")

" Read the colors from airline extension
let g:promptline_theme = "airline_insert"

fun! s:python_virtualenv(...)
	return "${VIRTUAL_ENV:+ } ${VIRTUAL_ENV##*/}"
endfun

fun! s:conda_env(...)
	return "${CONDA_DEFAULT_ENV:+ } ${CONDA_DEFAULT_ENV##*/}"
endfun

let g:promptline_preset = {
	\"a"    : [promptline#slices#host({ "only_if_ssh": 1 }), promptline#slices#cwd({"dir_limit":2})],
	\"x"    : [promptline#slices#jobs()],
	\"y"    : [promptline#slices#vcs_branch(), promptline#slices#git_status()],
	\"z"    : [s:conda_env(), s:python_virtualenv()],
	\"warn" : [promptline#slices#last_exit_code()],
	\"options": {
		\"left_sections" : ["a", "warn"],
		\"right_sections" : ["x", "y", "z"],
		\"left_only_sections" : ["a", "x", "y", "z", "warn"]
	\ }
\}
