if [[ "$OSTYPE" == "darwin"* ]]; then
	alias ls='ls -hG'
	alias ll='ls -lhG'
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	alias ls='ls -h --color=auto'
	alias ll='ls -lh --color=auto'
fi
alias grep='grep --color=auto'
type bat &> /dev/null && alias cat='bat'
type nvim &> /dev/null && alias vim='nvim'
type python3 &> /dev/null && alias python='python3'

function docker-shell () {
	docker run \
		--interactive --tty --rm \
		--workdir "/workspace" --mount "type=bind,source=${PWD},target=/workspace/$(basename ${PWD})" "$@"
}

# Aliases for pasteboard to mimic MacOS'
if is_linux ; then
	if is_wsl ; then
		alias pbcopy="clip.exe"
		alias pbpaste="powershell.exe -c Get-Clipboard"
	else
		if type xsel &> /dev/null ; then
			alias pbcopy="xsel --clipboard"
			alias pbpaste="xsel --clipboard"
		elif type xclip &> /dev/null ; then
			alias pbcopy="xclip -selection clipboard"
			alias pbpaste="xclip -o -selection clipboard"
		fi
	fi
fi
