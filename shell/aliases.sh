if [[ "$OSTYPE" == "darwin"* ]]; then
	alias ls='ls -hG'
	alias ll='ls -lhG'
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	alias ls='ls -h --color=auto'
	alias ll='ls -lh --color=auto'
fi
alias grep='grep --color=auto'
type -P bat &> /dev/null && alias cat='bat'
type -P nvim &> /dev/null && alias vim='nvim'
type -P python3 &> /dev/null && alias python='python3'
