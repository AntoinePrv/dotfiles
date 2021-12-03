# Auto-install zinit plugin manager if not present and source it.
function initialize_zinit {
	local -r url="https://github.com/zdharma-continuum/zinit/archive/refs/tags/v${1}.tar.gz"
	local -r dest="$2"
	if [[ ! -f "${dest}/zinit.zsh" ]]; then
		mkdir -p "${dest}"
		curl -sL "${url}" | tar -xz -C "${dest}" --strip-component=1
	fi
	source "${dest}/zinit.zsh"
}

# Setup path and initalize zinit
declare -A ZINIT
ZINIT[HOME_DIR]="${XDG_DATA_HOME}/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/zinit"
initialize_zinit "3.7" "${ZINIT[BIN_DIR]}"

# Provides sbin etc. ice for managing programs as shims
zinit ice compile
zinit light @zdharma-continuum/z-a-bin-gem-node

# Install base16-shell but don't source code to avoid polluting the completion
zinit ice cloneonly
zinit light "chriskempson/base16-shell"
export BASE16_DIR="$(zinit cd "chriskempson/base16-shell" &> /dev/null && pwd)"

zinit ice lucid from='gh' if='[[ "$(uname)" == Darwin* ]]' \
	atclone='swiftc -o dark-mode dark-mode.swift' atpull="%atclone" sbin='dark-mode'
zinit light @AntoinePrv/dark-mode

zinit ice lucid from='gh-r' mv='rip* ripgrep' sbin='**/rg(.exe|) -> rg'
zinit light @BurntSushi/ripgrep

zinit ice lucid from='gh-r' mv='fd* fd' sbin='**/fd(.exe|) -> fd'
zinit light @sharkdp/fd

zinit ice lucid from='gh-r' mv='bat* bat' sbin='**/bat(.exe|) -> bat'
zinit light @sharkdp/bat

zinit ice lucid from='gh-r' sbi='**/fzf(.exe|) -> fzf'
zinit light @junegunn/fzf

zinit ice wait compile lucid blockf
zinit light @zsh-users/zsh-completions

# Should be loaded last and call again compinit after all (turbo) completion are loaded
zinit ice wait compile lucid atinit='ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay'
zinit light zdharma-continuum/fast-syntax-highlighting
