typeset -A ZI
ZI[HOME_DIR]="${XDG_DATA_HOME}/zi"
ZI[BIN_DIR]="${ZI[HOME_DIR]}/bin"
ZI[CACHE_DIR]="${XDG_CACHE_HOME}/zi"

if [ ! -f "${ZI[BIN_DIR]}/zi.zsh" ]; then
	source <(curl -sL git.io/zi-loader); zzinit
fi
source "${ZI[BIN_DIR]}/zi.zsh"

# Provides sbin etc. ice for managing programs as shims
zi ice compile
zi light @z-shell/z-a-bin-gem-node

zi ice lucid from='gh' if='[[ "$(uname -s)" == Darwin* ]]' \
	atclone='swiftc -o dark-mode macos/dark-mode.swift' atpull='%atclone' sbin='dark-mode'
zi light @AntoinePrv/dark-mode
zi ice lucid from='gh' if='[[ "$(uname -s)" == Linux* ]]' \
	sbin='linux/gnome/dark-mode.sh -> dark-mode'
zi light @AntoinePrv/dark-mode

zi ice wait compile lucid blockf
zi light @zsh-users/zsh-completions

# Should be loaded last and call again compinit after all (turbo) completion are loaded
zi ice wait compile lucid atload='zicompinit; zicdreplay'
zi light zdharma-continuum/fast-syntax-highlighting

autoload -Uz compinit && compinit -i
zi cdreplay

function __generate_completion_for_exe () {
	local -r exe="${1}"
	if type "${exe}" &> /dev/null; then
		# local -r file_path="${USER_ZSH_COMPLETION_DIR}/${exe}-${sha}"
		# Modifying filename does not work with gh completion...
		# local -r sha="$("${exe}" --version | sha256sum | cut -d' ' -f1)"
		local -r file_path="${USER_ZSH_COMPLETION_DIR}/_${exe}"
		if [[ ! -f "${file_path}" ]]; then
			# Call the completion command
			mkdir -p "${USER_ZSH_COMPLETION_DIR}"
			"${@:2}" > "${file_path}"
		fi
		local -r file_name="$(basename ${file_path})"
		autoload -Uz "${file_name}"
		compdef "${file_name}" "${exe}"
	fi
}

function __generate_completion () {
		# When the executable has the same name it can be omitted with this function
	__generate_completion_for_exe "${1}" "${@}"
}

# Other completions
export USER_ZSH_COMPLETION_DIR="${XDG_DATA_HOME}/zsh/site-functions"
__generate_completion pixi completion --shell zsh
__generate_completion rg --generate=complete-zsh
__generate_completion gh completion --shell zsh
__generate_completion rustup completions zsh rustup
__generate_completion_for_exe cargo rustup completions zsh cargo
