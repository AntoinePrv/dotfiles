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
