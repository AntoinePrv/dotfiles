" Parametrize tmux status line using Tmux plugin

let g:tmuxline_theme = 'airline'

function! TmuxvarResolve_var(name)
	" Get current value from current tmux environment
	let l:command = 'OUT=$(tmux showenv __TMUX#{pane_id}_'.a:name.') && '
	" OUT value has pattern similar to __TMUX%0_PWD=/there. Cutting prefix
	" Remeber to escape dollar signs as this is passed though a first shell before tmux
	let l:command = l:command . a:name.'=\\${OUT#__TMUX#{pane_id}_'.a:name.'=}'
	return l:command
endfunction

function! TmuxvarPwd()
	" Get PWD from shell env (tmux resolution may not resolve nested shells) and cd
	let l:command = TmuxvarResolve_var('PWD') . ' && cd \\$PWD && '
	let l:command = l:command . 'pwd | xargs basename'
	return ' #(' . l:command . ')'
endfunction

let s:current_dir = expand('<sfile>:p:h')  " Folder where this files exists
function! TmuxvarGit_branch()
	" Get PWD from shell env (tmux resolution may not resolve nested shells) and cd
	let l:command = TmuxvarResolve_var('PWD') . ' && cd \\$PWD && '
	let l:command = l:command . 'bash ' . s:current_dir . '/tmuxline-git.sh'
	return '#(' . l:command . ')'
endfunction

function! TmuxvarVirtualenv()
	let l:command = TmuxvarResolve_var('VIRTUAL_ENV') . ' && '
	let l:command = l:command . 'echo " $(basename \\$VIRTUAL_ENV)"'
	return '#(' . l:command . ')'
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
