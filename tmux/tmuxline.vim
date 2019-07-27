" Parametrize tmux status line using Tmux plugin

let g:tmuxline_theme = 'airline'

function! TmuxvarResolve_var(name)
	let command = a:name.'=$(tmux showenv __TMUX#{pane_id}_'.a:name.') && '
	let command = command . a:name.'=\\${'.a:name.'#__TMUX#{pane_id}_'.a:name.'=}'
	let command = command . ' && '
	return command
endfunction

function! TmuxvarPwd()
	let command = ' #('.TmuxvarResolve_var('PWD')
	let command = command . 'cd \\$PWD && pwd | xargs basename)'
	return command
endfunction

function! TmuxvarGit_branch()
	let command = '#('.TmuxvarResolve_var('PWD').'cd \\$PWD && '
	let command = command . '(git rev-parse --abbrev-ref HEAD && echo "") '
	let command = command . '| sed ''1!G;h;$!d''  | paste -sd " " -)'
	return command
endfunction

function! TmuxvarVirtualenv()
	let command = '#('.TmuxvarResolve_var('VIRTUAL_ENV')
	let command = command . 'echo " $(basename \\$VIRTUAL_ENV)")'
	return command
endfunction

let g:tmuxline_preset = {
	\'a'    : '%a %R',
	\'b'    : '#h',
	\'c'    : ' #S',
	\'cwin' : '#I:#W#F',
	\'win'  : '#I:#W',
	\'x'    : TmuxvarGit_branch(),
	\'y'    : TmuxvarPwd(),
	\'z'    : TmuxvarVirtualenv(),
	\'options' : {'status-justify': 'left'}
\}
