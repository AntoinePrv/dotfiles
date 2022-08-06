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
zinit light @zdharma-continuum/zinit-annex-bin-gem-node

# Install base16-shell but don't source code to avoid polluting the completion
zinit ice cloneonly
zinit light "base16-project/base16-shell"
export BASE16_DIR="$(zinit cd "base16-project/base16-shell" &> /dev/null && pwd)"

zinit ice lucid from='gh' if='[[ "$(uname -s)" == Darwin* ]]' \
	atclone='swiftc -o dark-mode dark-mode.swift' atpull="%atclone" sbin='dark-mode'
zinit light @AntoinePrv/dark-mode

zinit ice lucid from='gh-r' sbin='**/rg(.exe|) -> rg'
zinit light @BurntSushi/ripgrep

zinit ice lucid from='gh-r' sbin='**/fd(.exe|) -> fd'
zinit light @sharkdp/fd

# Add cp='autocomplete/bat.zsh -> _bat'
zinit ice lucid from='gh-r' sbin='**/bat(.exe|) -> bat'
zinit light @sharkdp/bat

zinit ice lucid id-as='junegunn/fzf:bin' from='gh-r' sbin='**/fzf(.exe|) -> fzf'
zinit light @junegunn/fzf

# This is for using fzf with completions
zini ice lucid id-as='junegunn/fzf:fuzzy-completions' cp='shell/completion.zsh -> _fzf_fuzzy_completions'
zinit light @junegunn/fzf

zinit ice lucid from='gh-r' sbin='**/gh(.exe|) -> gh'
zinit light @cli/cli

zinit ice lucide from='gh-r' sbin='**/task(.exe|) -> task'
zinit light @go-task/task

# For downloading arbitrary assets from URLs
zinit light @zdharma-continuum/zinit-annex-readurl

case "$(uname -s)" in
	Darwin*)
		conda_os="osx" ;;
	Linux*)
		conda_os="linux" ;;
esac
case "$(uname -m)" in
	x86_64)
		conda_arch="64" ;;
esac
# micromamba is bound as both function and script because function is necessary for activation
# but not visible in programs (maybe easier to simply add in PATH using cmd).
zinit ice lucid id-as='conda-forge/micromamba' as='readurl|null' extract \
	fbin='bin/micromamba -> micromamba' sbin='bin/micromamba -> micromamba' \
	atload='eval "$(micromamba shell hook -s posix)"'\
	dlink="/conda-forge/micromamba/%VERSION%/download/${conda_os}-${conda_arch}/micromamba-%VERSION%-*.tar.bz2"
zinit snippet https://anaconda.org/conda-forge/micromamba/files

zinit ice wait compile lucid blockf
zinit light @zsh-users/zsh-completions

# Should be loaded last and call again compinit after all (turbo) completion are loaded
zinit ice wait compile lucid atinit='ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay'
zinit light zdharma-continuum/fast-syntax-highlighting
