# Useful variables
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export EDITOR=nvim

# Shell colors
export CLICOLOR=1

# Terminal Base16 color theme
THEME="pop"
THEME_SCRIPT="${HOME}/.local/share/base16/scripts/base16-${THEME}.sh"
if [[ -n "$PS1" && -s "$THEME_SCRIPT" ]]; then
	source "$THEME_SCRIPT"
fi

# Fzf color
export FZF_DEFAULT_OPTS='--color=16'

# Prompt
export PROMPT_COMMAND=''
if [[ "$TERM" == screen* ]] && [ -n "$TMUX" ]; then
	source "${DIR}/tmux-prompt.sh"
	source "${DIR}/tmux-update.sh"
else
	source "${DIR}/default-prompt.sh"
fi

# Add path for executable
export PATH="/usr/local/bin:/usr/local/sbin:${PATH}"
export PATH="${HOME}/.local/bin:${PATH}"

# Python tools
export PYTHONBREAKPOINT="ipdb.set_trace"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init -)"
fi
