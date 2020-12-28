# Pane local environment variable in tmux environment.
# Update the value of an environment variable from the current pane to a
# pane-local variable in tmux environment.
# The pane-local varaible is emulated using the pane-id.
function __update_local_env () {
	if [ -z "${!1}" ]; then
		tmux setenv -u "__TMUX${TMUX_PANE}_$1"
	else
		tmux setenv "__TMUX${TMUX_PANE}_$1" "${!1}"
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

# Upadte PROMPT_COMMAND
if [[ ! "$PROMPT_COMMAND" == *__update_tmux* ]]; then
	export PROMPT_COMMAND+='__update_tmux;'
fi
