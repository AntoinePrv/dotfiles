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

function is_in_ssh () {
	[[ -n "${SSH_CLIENT}" || -n "${SSH_TTY}" ]] && return 0 || return 1
}

function is_in_tmux () {
	[[ "${TERM}" = "screen"* &&  -n "${TMUX}" ]] && return 0 || return 1
}

function is_macos () {
	[[ "$OSTYPE" == "darwin"* ]] && return 0 || return 1
}

function is_linux () {
	[[ "$OSTYPE" == "linux"* ]] && return 0 || return 1
}

function is_wsl () {
	grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null && return 0 || return 1
}

export BASE16_LIGHT_THEME="one-light"
export BASE16_DARK_THEME="onedark"

function base16 (){
	if [ "$1" = "light" ]; then
		local -r theme="${BASE16_LIGHT_THEME}"
	elif [ "${1}" = "dark" ]; then
		local -r theme="${BASE16_DARK_THEME}"
	else
		local -r theme="${1}"
	fi
	bash "${BASE16_DIR}/scripts/base16-${theme}.sh"
}

function set_theme () {
	if is_macos && (! is_in_tmux) && (! is_in_ssh); then
		(
			dark-mode base16 --root "${BASE16_DIR}" \
				--light "${BASE16_LIGHT_THEME}" --dark "${BASE16_DARK_THEME}" &
			bash -c "while ps -p $$ 2>&1 1>/dev/null; do sleep 600; done; pkill -P $!" &
		)
	else
		bash "${BASE16_DIR}/scripts/base16-${dark}.sh"
	fi
}

# Terminal Base16 color theme

if ! {is_in_tmux || is_in_ssh}; then
	set_theme
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
if is_in_tmux ; then
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
if python3 -c 'import importlib.util as u; exit(u.find_spec("IPython") is None)' &> /dev/null ; then
	export PYTHONBREAKPOINT="ipdb.set_trace"
	export PYTEST_ADDOPTS="--pdbcls=ipdb:__main__.debugger_cls"
fi

# CCache directory
export CCACHE_DIR="${XDG_CACHE_HOME}/ccache"

# Conan cache directory
export CONAN_USER_HOME="${XDG_CACHE_HOME}/conan"
