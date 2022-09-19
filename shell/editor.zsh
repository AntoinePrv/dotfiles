autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES

# Dynamicaly change cursor shape in command/insertion mode
# https://archive.emily.st/2013/05/03/zsh-vi-cursor/
# https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim

# TODO should this be using hook rather than redifining?
function zle-keymap-select zle-line-init {
	case $KEYMAP in
		vicmd)      echo -ne "\e[2 q";;  # block cursor
		viins|main) echo -ne "\e[5 q";;  # line cursor
	esac
	zle reset-prompt
	zle -R
}

function zle-line-finish {
	echo -ne "\e[2 q"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# Keybindings
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey '^R' history-incremental-search-backward

# From Arch wiki https://wiki.archlinux.org/index.php/Zsh

# Create a zkbd compatible hash to add other keys to this hash, see: man 5 terminfo.
typeset -g -A key

# Fetch escape sequence for keys
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"

# Define the history search as zle widgets
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Setup key accordingly
[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# Finally, make sure the terminal is in application mode, when zle is active.
# Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
