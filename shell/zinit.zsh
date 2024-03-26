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

# Install base16-shell but don't source code to avoid polluting the completion
zi ice cloneonly
zi light 'tinted-theming/base16-shell'
export BASE16_DIR="$(zi cd 'tinted-theming/base16-shell' &> /dev/null && pwd)"

zi ice lucid from='gh' if='[[ "$(uname -s)" == Darwin* ]]' \
	atclone='swiftc -o dark-mode macos/dark-mode.swift' atpull='%atclone' sbin='dark-mode'
zi light @AntoinePrv/dark-mode
zi ice lucid from='gh' if='[[ "$(uname -s)" == Linux* ]]' \
	sbin='linux/gnome/dark-mode.sh -> dark-mode'
zi light @AntoinePrv/dark-mode

zi ice lucid from='gh-r' sbin='**/rg(.exe|) -> rg'
zi light @BurntSushi/ripgrep

zi ice lucid from='gh-r' sbin='**/fd(.exe|) -> fd'
zi light @sharkdp/fd

# Add cp='autocomplete/bat.zsh -> _bat'
zi ice lucid from='gh-r' sbin='**/bat(.exe|) -> bat'
zi light @sharkdp/bat

zi ice lucid id-as='junegunn/fzf:bin' from='gh-r' sbin='**/fzf(.exe|) -> fzf'
zi light @junegunn/fzf

# This is for using fzf with completions
zini ice lucid id-as='junegunn/fzf:fuzzy-completions' cp='shell/completion.zsh -> _fzf_fuzzy_completions'
zi light @junegunn/fzf

zi ice lucid from='gh-r' sbin='**/gh(.exe|) -> gh' atclone='gh completion -s zsh > _gh' atpull='%atclone'
zi light @cli/cli

zi ice lucid from='gh-r' sbin='**/task(.exe|) -> task'
zi light @go-task/task

# For downloading arbitrary assets from URLs
zi light @z-shell/z-a-readurl

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
zi ice lucid id-as='conda-forge/micromamba' as='readurl|command' extract \
	pick="bin/micromamba" \
	atload='eval "$(micromamba shell hook --shell zsh)"' \
	dlink="/conda-forge/micromamba/%VERSION%/download/${conda_os}-${conda_arch}/micromamba-%VERSION%-*.tar.bz2"
zi snippet 'https://anaconda.org/conda-forge/micromamba/files'
export MAMBA_EXE="$(zi cd "conda-forge/micromamba" &> /dev/null && pwd)/bin/micromamba"

zi ice wait compile lucid blockf
zi light @zsh-users/zsh-completions

# Should be loaded last and call again compinit after all (turbo) completion are loaded
zi ice wait compile lucid atload='zicompinit; zicdreplay'
zi light zdharma-continuum/fast-syntax-highlighting

autoload -Uz compinit && compinit
zi cdreplay
