# Pane local environment variable in tmux environment.
# Update the value of an environment variable from the current pane to a
# pane-local variable in tmux environment.
# The pane-local variable is emulated using the pane-id.
function __update_local_env () {
	local -r var_name="$1"
	local -r var_val="$(eval "printf %s \$$var_name")"
	if [ -z "${var_val}" ]; then
		tmux setenv -u "__TMUX${TMUX_PANE}_${var_name}"
	else
		tmux setenv "__TMUX${TMUX_PANE}_${var_name}" "${var_val}"
	fi
}


# Function called by PROMPT_COMMAND
function __update_tmux () {
	__update_local_env 'VIRTUAL_ENV'
	__update_local_env 'CONDA_DEFAULT_ENV'
	__update_local_env 'PWD'
	# Update the status line
	tmux refresh-client -S
}

if [ -n "$BASH_VERSION" ]; then
	if [[ ! "$PROMPT_COMMAND" == *__update_tmux* ]]; then
		export PROMPT_COMMAND+='__update_tmux;'
	fi
elif [ -n "$ZSH_VERSION" ]; then
	precmd_functions+=(__update_tmux)
	typeset -U precmd_functions  # Remove duplicate in array
fi
