alias ls='ls -Gh'
alias ll='ls -l'
alias vim='nvim'
alias python='python3'
alias grep='grep --color=auto'

pyfind () {
	find ${2-"."} -name '*.py' -exec grep $1 {} +
}
