if [[ "$OSTYPE" == "darwin"* ]]; then
	alias ls='ls -hG'
	alias ll='ls -lhG'
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	alias ls='ls -h --color=auto'
	alias ll='ls -lh --color=auto'
fi
alias cpy="clipboard copy"
alias pst="clipboard paste"
alias grep='grep --color=auto'
type bat &> /dev/null && alias cat='bat'
type nvim &> /dev/null && alias vim='nvim'
alias git-tree='rg --files | tree --fromfile'

alias tinty='tinty -d "${USER_TINTED_THEMING_DIR}" -c "${XDG_CONFIG_HOME}/misc/tinty.toml"'

function docker-shell () {
	docker run \
		--interactive --tty --rm \
		--workdir "/workspace/$(basename ${PWD})" \
		--mount "type=bind,source=${PWD},target=/workspace/$(basename ${PWD})" \
		--volume /var/run/docker.sock:/var/run/docker.sock \
		"$@"
}
