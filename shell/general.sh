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

function set_theme() {
    # TODO find a better way to run in the background? Or make is an executable?
    if [[ "${OSTYPE}" == "darwin"* || "${OSTYPE}" == "linux"* ]]; then
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

if [[ -z "${TMUX}" && -z "${SSH_CLIENT}" && -z "${SSH_TTY}" ]]; then
    # Terminal Base16 color theme
    set_theme
    # Start the ssh-agent if it is not started and track the socket.
    # ssh-add is handled by the .ssh/config
    eval "$(ssh-agent -s)" &> /dev/null
    # Reset environment variable
    export TERM=xterm-256color
    export LANG=C.UTF-8
    export LC_CTYPE=C.UTF-8
fi

# Fzf color
export FZF_DEFAULT_OPTS='--color=16'

# Bat color
export BAT_THEME='base16'

# Use bat as man pager if available
type -P bat &> /dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

if python3 -c 'import importlib.util as u; exit(u.find_spec("IPython") is None)' &> /dev/null; then
    export PYTHONBREAKPOINT="ipdb.set_trace"
    export PYTEST_ADDOPTS="--pdbcls=IPython.core.debugger:Pdb"
fi

# Tmuxp configuration directory (user-shell config, kept out of tool_storage_env)
export TMUXP_CONFIGDIR="${XDG_CONFIG_HOME}/tmuxp"

export ZELLIJ_CONFIG_DIR="${XDG_CONFIG_HOME}/zellij"

if [[ "${OSTYPE}" == "darwin"* ]]; then
    # For CMake to poperly find package
    export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
fi
