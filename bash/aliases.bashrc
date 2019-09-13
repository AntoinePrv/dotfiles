alias ls='ls -Gh'
alias ll='ls -l'
alias grep='grep --color=auto'
type -P bat &> /dev/null && alias cat='bat'
type -P nvim &> /dev/null && alias vim='nvim'
type -P python3 &> /dev/null && alias python='python3'

pyfind () {
	find ${2-"."} -name '*.py' -exec grep $1 {} +
}
