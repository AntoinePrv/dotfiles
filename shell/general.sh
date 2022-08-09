# Add path for executable if not aleard there
for x in "/usr/local/bin" "/usr/local/sbin" "${HOME}/.local/bin"; do
	case ":$PATH:" in
		*":$x:"*) : ;; # already there
		*) PATH="$x:$PATH";;
	esac
done
export PATH

export EDITOR=nvim

# Shell history
export HISTFILE="${XDG_DATA_HOME}/$(basename "${SHELL}")/history"
export SAVEHIST=10000
mkdir -p "$(dirname "${HISTFILE}")"

# Shell colors
export CLICOLOR=1


export BASE16_LIGHT_THEME="one-light"
export BASE16_DARK_THEME="onedark"


function base16 (){
	if [ "$1" = "light" ]; then
		bash "${BASE16_DIR:?}/scripts/base16-${BASE16_LIGHT_THEME}.sh"
	elif [ "${1}" = "dark" ]; then
		bash "${BASE16_DIR:?}/scripts/base16-${BASE16_DARK_THEME}.sh"
	else
		bash "${BASE16_DIR:?}/scripts/base16-${1}.sh"
	fi
}

# TODO: Make this into a proper package
if is-this wsl; then
	function powershell () {
			/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe "$@"
	}

	function dark-mode () {
		if [ "$1" = "light" ]; then
			base16 light
			powershell Set-ItemProperty \
				-Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' \
				-Name AppsUseLightTheme \
				-Value 1
		elif [ "${1}" = "dark" ]; then
			base16 dark
			powershell Set-ItemProperty \
				-Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' \
				-Name AppsUseLightTheme \
				-Value 0
		else
			echo "Invalid value ${1}" 1>&2
			return 1
		fi
	}
fi

function set_theme () {
	if is-this macos && (! is-this tmux) && (! is-this ssh); then
		(
			dark-mode base16 --root "${BASE16_DIR:?}" \
				--light "${BASE16_LIGHT_THEME}" --dark "${BASE16_DARK_THEME}" &
			bash -c "while ps -p $$ 2>&1 1>/dev/null; do sleep 600; done; pkill -P $!" &
		)
	else
		base16 dark
	fi
}


if ! {is-this tmux || is-this ssh}; then
	# Terminal Base16 color theme
	set_theme
	# Start the ssh-agent if it is not started and track the socket.
	# ssh-add is handled by the .ssh/config
	eval "$(ssh-agent -s)" &> /dev/null
fi

if is-this wsl; then
	# Fix for tmux on openSuse with WSL2. https://github.com/microsoft/WSL/issues/2530
	export TMUX_TMPDIR="/tmp/${USER}/tmux"
	mkdir -p "${TMUX_TMPDIR}"
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

# Initialize conda if found
conda_exe="${CONDA_EXE:-conda}"
type "${conda_exe}" &> /dev/null && eval "$("${conda_exe}" "shell.$(basename "${SHELL}")" hook)"
unset conda_exe
# Fix Tmux Conda path conflict
if is-this tmux ; then
	conda deactivate &> /dev/null
	conda activate base &> /dev/null
fi

# Mamba package and environments prefix
export MAMBA_ROOT_PREFIX="${XDG_DATA_HOME}/mamba"

# Tmuxp configuration directory
export TMUXP_CONFIGDIR="${XDG_CONFIG_HOME}/tmuxp"

# Python tools
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/cpython"
export WORKON_HOME="${XDG_DATA_HOME}/pipenv/venvs"
export PIP_CACHE_DIR="${XDG_CACHE_HOME}/pip"
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"
if python3 -c 'import importlib.util as u; exit(u.find_spec("IPython") is None)' &> /dev/null ; then
	export PYTHONBREAKPOINT="ipdb.set_trace"
	export PYTEST_ADDOPTS="--pdbcls=IPython.core.debugger:Pdb"
fi

# CCache directory
export CCACHE_DIR="${XDG_CACHE_HOME}/ccache"

# Conan cache directory
export CONAN_USER_HOME="${XDG_CACHE_HOME}/conan"

# GPG
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"

# Task
export TASK_TEMP_DIR="${XDG_CACHE_HOME}/taskfile"
