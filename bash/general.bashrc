# Useful variables
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Add path for executable if not aleard there
for x in "/usr/local/bin" "/usr/local/sbin" "${HOME}/.local/bin"; do
	case ":$PATH:" in
		*":$x:"*) : ;; # already there
		*) PATH="$x:$PATH";;
	esac
done
export PATH

# Initialize conda
__conda_setup="$(conda shell.bash hook 2> /dev/null)" && eval "$__conda_setup"
unset __conda_setup

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

# Bat color
export BAT_THEME='base16'

# Use bat as man pager if available
type -P bat &> /dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Prompt
export PROMPT_COMMAND=''
if [[ "$TERM" == screen* ]] && [ -n "$TMUX" ]; then
	source "${DIR}/tmux-prompt.sh"
	source "${DIR}/tmux-update.sh"

	# Fix Tmux Conda path conflict
	conda deactivate &> /dev/null
	conda activate base &> /dev/null
else
	source "${DIR}/default-prompt.sh"
fi

# Python tools
export PYTHONBREAKPOINT="ipdb.set_trace"
export PYTHONPYCACHEPREFIX="${CACHE_DIR}/cpython"
export WORKON_HOME="${WORKSPACE_DIR}/venvs"

# Conda directories
export CONDA_ENVS_PATH="${WORKSPACE_DIR}/conda/envs"
export CONDA_PKGS_DIRS="${CACHE_DIR}/conda/pkgs"
