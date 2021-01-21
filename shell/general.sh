# Add path for executable if not aleard there
for x in "/usr/local/bin" "/usr/local/sbin" "${HOME}/.local/bin"; do
	case ":$PATH:" in
		*":$x:"*) : ;; # already there
		*) PATH="$x:$PATH";;
	esac
done
export PATH

export EDITOR=nvim

# Shell colors
export CLICOLOR=1

# Terminal Base16 color theme
THEME="pop"
THEME_SCRIPT="${XDG_DATA_HOME}/base16/scripts/base16-${THEME}.sh"
if [[ -n "$PS1" && -s "$THEME_SCRIPT" ]]; then
	source "$THEME_SCRIPT"
fi

# Fzf color
export FZF_DEFAULT_OPTS='--color=16'

# Bat color
export BAT_THEME='base16'

# Use bat as man pager if available
type -P bat &> /dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Conda directories
export CONDA_ENVS_PATH="${XDG_DATA_HOME}/conda/envs"
export CONDA_PKGS_DIRS="${XDG_CACHE_HOME}/conda/pkgs"
export CONDA_BLD_PATH="${XDG_CACHE_HOME}/conda/channel"

# Initialize conda
__conda_setup="$(conda shell.bash hook 2> /dev/null)" && eval "$__conda_setup"
unset __conda_setup

# Fix Tmux Conda path conflict
if [[ "$TERM" == screen* ]] && [ -n "$TMUX" ]; then
	conda deactivate &> /dev/null
	conda activate base &> /dev/null
fi

# Tmuxp configuration directory
export TMUXP_CONFIGDIR="${XDG_CONFIG_HOME}/tmuxp"

# Python tools
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/cpython"
export WORKON_HOME="${XDG_DATA_HOME}/pipenv/venvs"
export PIP_CACHE_DIR="${XDG_CACHE_HOME}/pip"
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"
if python -c 'import importlib.util as u; exit(u.find_spec("IPython") is None)' ; then
	export PYTHONBREAKPOINT="ipdb.set_trace"
	export PYTEST_ADDOPTS="--pdbcls=ipdb:__main__.debugger_cls"
fi

# CCache directory
export CCACHE_DIR="${XDG_CACHE_HOME}/ccache"

# Conan cache directory
export CONAN_USER_HOME="${XDG_CACHE_HOME}/conan"
