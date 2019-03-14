# Useful variables
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# Set vim editing style and editor
set -o vi
export EDITOR=nvim

# Terminal colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Prompt
if [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; then
	source "${DIR}/tmux-prompt.sh"
else
	source "${DIR}/default-prompt.sh"
fi

# Add path for executable
export PATH="$HOME"'/.local/bin':"$PATH"
export PATH=$PATH:/usr/local/bin

# Python tools
export PYTHONBREAKPOINT="ipdb.set_trace"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init -)"
fi

# Pipenv completion
eval "$(pipenv --completion)"
eval "$(pip completion --bash)"
