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
zi light 'tinted-theming/tinted-shell'
export BASE16_DIR="$(zi cd 'tinted-theming/base16-shell' &> /dev/null && pwd)"

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

autoload -Uz compinit && compinit
zi cdreplay
