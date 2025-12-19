#!/usr/bin/env bash

# TODO brew / apt / pixi / pixi-global

symlink() {
    local src=$1 dst=$2 recursive=$3
    if [[ -d "$src" && "$recursive" == "true" ]]; then
        find "$src" -type f | while read -r file; do
            symlink "$file" "$dst/${file#$src/}"
        done
    else
        mkdir -p "$(dirname "$dst")"
        ln -sfn "$src" "$dst"
    fi
}

hardlink() {
    mkdir -p "$(dirname "$2")"
    ln -f "$1" "$2"
}

install_dotfiles() {
    local root conf
    root=$(cd "$(dirname "$0")" && pwd)
    conf="${XDG_CONFIG_HOME:-$HOME/.config}"

    # Use recursive=true for shared bin directory
    symlink "$root/bin" "$HOME/.local/bin" "true"

    for d in shell nvim tmux tmuxp git misc; do symlink "$root/$d" "$conf/$d"; done

    symlink "$conf/shell/profile"    "$HOME/.profile"
    symlink "$conf/shell/profile"    "$HOME/.zprofile"
    symlink "$conf/shell/bashrc"     "$HOME/.bashrc"
    symlink "$conf/shell/zshrc"      "$HOME/.zshrc"
    symlink "$conf/tmux/tmux.conf"   "$HOME/.tmux.conf"
    symlink "$conf/misc/inputrc"     "$HOME/.inputrc"
    symlink "$conf/misc/editrc"      "$HOME/.editrc"
    symlink "$conf/misc/condarc"     "$HOME/.condarc"

    symlink "$root/misc/alacritty.toml"  "$conf/alacritty/alacritty.toml"
    symlink "$root/misc/ipython"         "$conf/ipython"
    symlink "$root/misc/clangd.yaml"     "$conf/clangd/config.yaml"
    hardlink "$root/misc/karabiner.json" "$conf/karabiner/karabiner.json"

    nvim -n --headless +'autocmd User PackerComplete quitall' +'PackerSync' +'qa!'
}

install_dotfiles
