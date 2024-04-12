# Configuration specific to machines / networks

# Default values
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export USER_ZSH_COMPLETION_DIR="${XDG_DATA_HOME}/zsh/site-functions"
export WORKSPACE_DIR="${HOME}/workspace"

mkdir -p "${XDG_CONFIG_HOME}"
mkdir -p "${XDG_CACHE_HOME}"
mkdir -p "${XDG_DATA_HOME}"
mkdir -p "${WORKSPACE_DIR}"
mkdir -p "${USER_ZSH_COMPLETION_DIR}"
