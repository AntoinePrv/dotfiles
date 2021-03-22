# Auto-install zinit plugin manager if not present and source it.
function initialize_zinit {
	local -r url="https://github.com/zdharma/zinit/archive/refs/tags/v${1}.tar.gz"
	local -r dest="$2"
	if [[ ! -f "${dest}/zinit.zsh" ]]; then
		mkdir -p "${dest}"
		curl -sL "${url}" | tar -xz -C "${dest}" --strip-component=1
	fi
	source "${dest}/zinit.zsh"
}

# Setupt path and initalize zinit
declare -A ZINIT
ZINIT[HOME_DIR]="${XDG_DATA_HOME}/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/zinit"
initialize_zinit "3.7" "${ZINIT[BIN_DIR]}"
