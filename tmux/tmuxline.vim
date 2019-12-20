" Parametrize tmux status line using Tmux plugin

let g:tmuxline_theme = 'airline'

function! TmuxlineCurrentWindow()
	" Delete active window flag (*) replaced by () and change other flag characters
	let l:command = 'printf "#F" | tr -d "*" | tr "Z" "ﬕ"'
	return ' #W #(' . command . ')'
endfunction

function! TmuxlineResolveVar(name)
	" Get current value from current tmux environment
	let l:command = 'OUT=$(tmux showenv __TMUX#{pane_id}_'.a:name.') && '
	" OUT value has pattern similar to __TMUX%0_PWD=/there. Cutting prefix
	" Remeber to escape dollar signs as this is passed though a first shell before tmux
	let l:command = l:command . a:name.'=\\${OUT#__TMUX#{pane_id}_'.a:name.'=}'
	return l:command
endfunction

function! TmuxlinePwd()
	" Get PWD from shell env (tmux resolution may not resolve nested shells) and cd
	let l:command = TmuxlineResolveVar('PWD') . ' && cd \\$PWD && '
	let l:command = l:command . 'pwd | xargs basename'
	return ' #(' . l:command . ')'
endfunction

let s:current_dir = expand('<sfile>:p:h')  " Folder where this files exists
function! TmuxlineGitStatus()
	" Get PWD from shell env (tmux resolution may not resolve nested shells) and cd
	let l:command = TmuxlineResolveVar('PWD') . ' && cd \\$PWD && '
	let l:command = l:command . 'bash ' . s:current_dir . '/tmuxline-git.sh'
	return '#(' . l:command . ')'
endfunction

function! TmuxlineVirtualEnv()
	let l:command = '(' . TmuxlineResolveVar('CONDA_DEFAULT_ENV')
	let l:command = l:command . ' && printf " \\${CONDA_DEFAULT_ENV?}") && space=" "; '
	let l:command = l:command . '(' . TmuxlineResolveVar('VIRTUAL_ENV')
	let l:command = l:command . ' && printf "\\${space} \\$(basename \\$VIRTUAL_ENV)")'
	return '#(' . l:command . ')'
endfunction

let g:tmuxline_preset = {
	\'a'    : '%a %R',
	\'b'    : ' #h',
	\'c'    : ' #S',
	\'cwin' : TmuxlineCurrentWindow(),
	\'win'  : '#I #W',
	\'x'    : TmuxlineGitStatus(),
	\'y'    : TmuxlinePwd(),
	\'z'    : TmuxlineVirtualEnv(),
	\'options' : {'status-justify': 'left'}
\}
