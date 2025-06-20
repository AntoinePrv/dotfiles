# Add path for executable if not aleard there
for x in "/usr/local/bin" "/usr/local/sbin" "${HOME}/.local/bin"; do
	case ":$PATH:" in
		*":$x:"*) : ;; # already there
		*) export PATH="$x:$PATH";;
	esac
done
if [ -d "/opt/homebrew/bin" ]; then
	export PATH="/opt/homebrew/bin:${PATH}"
fi

# Add zsh functions (used im completion)
if type -P brew &> /dev/null; then
	FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
FPATH="${USER_ZSH_COMPLETION_DIR}:${FPATH}"

export EDITOR=nvim

# Number of commands saved in memory
export HISTSIZE=100000
# Shell history
export HISTFILE="${XDG_DATA_HOME}/$(basename "${SHELL}")/history"
mkdir -p "$(dirname "${HISTFILE}")"
# Number of commands saved in in HISTFILE
export SAVEHIST=${HISTSIZE}

# Shell colors
export CLICOLOR=1


export USER_TINTED_THEMING_DIR="${XDG_DATA_HOME}/tinted-theming"

export BASE16_LIGHT_THEME="base16-humanoid-light"
export BASE16_DARK_THEME="base16-humanoid-dark"
export BASE16_SHELL_SET_BACKGROUND="true"


function set_theme () {
	# TODO find a better way to run in the background? Or make is an executable?
	if is-this macos || is-this linux; then
		(
			# Broken in https://github.com/tinted-theming/tinted-shell/pull/52
			export TTY="$(tty)"
			dark-mode listen \
				--dark "${BASE16_DARK_THEME}" \
				--light "${BASE16_LIGHT_THEME}" \
				tinty \
					-d "${USER_TINTED_THEMING_DIR}" \
					-c "${XDG_CONFIG_HOME}/misc/tinty.toml" \
					apply \
				&
			bash -c "while ps -p $$ 2>&1 1>/dev/null; do sleep 600; done; pkill -P $!" &
		)
	else
		tinty \
			-d "${USER_TINTED_THEMING_DIR}" \
			-c "${XDG_CONFIG_HOME}/misc/tinty.toml" \
			init
	fi
}


if ! {is-this tmux || is-this ssh}; then
	# Terminal Base16 color theme
	set_theme
	# Start the ssh-agent if it is not started and track the socket.
	# ssh-add is handled by the .ssh/config
	eval "$(ssh-agent -s)" &> /dev/null
fi

# Fzf color
export FZF_DEFAULT_OPTS='--color=16'

# Bat color
export BAT_THEME='base16'

# Use bat as man pager if available
type -P bat &> /dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Conda directories
export CONDA_ENVS_DIRS="${XDG_DATA_HOME}/conda/envs"
export CONDA_PKGS_DIRS="${XDG_CACHE_HOME}/conda/pkgs"
export CONDA_BLD_PATH="${XDG_CACHE_HOME}/conda/build"

# Pixi directories
export PIXI_HOME="${XDG_DATA_HOME}/pixi"
export PIXI_CACHE_DIR="${XDG_CACHE_HOME}/pixi"
export RATTLER_CACHE_DIR="${XDG_CACHE_HOME}/rattler"

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

# JupyterLab directories
export JUPYTERLAB_SETTINGS_DIR="${XDG_DATA_HOME}/jupyter"
export JUPYTERLAB_WORKSPACES_DIR="${XDG_DATA_HOME}/jupyter/lab/workspaces"

# CCache directory
export CCACHE_DIR="${XDG_CACHE_HOME}/ccache"
export SCCACHE_DIR="${XDG_CACHE_HOME}/sccache"

# Conan cache directory
export CONAN_USER_HOME="${XDG_CACHE_HOME}/conan"

# GPG
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"

# Task
export TASK_TEMP_DIR="${XDG_CACHE_HOME}/taskfile"

# Cargo and rust tools
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"

# Npm
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"

# Playwright
export PLAYWRIGHT_BROWSERS_PATH="${XDG_DATA_HOME}/playwright"

export PATH="${CARGO_HOME}/bin:${PATH}"
export PATH="${PIXI_HOME}/bin:${PATH}"


if is-this macos; then
	# For CMake to poperly find package
	export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
fi
