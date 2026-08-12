#!/usr/bin/env bash

ROOT=$(cd "$(dirname "$0")" && pwd)

function symlink() {
    local src="${1}" dst="${2}" recursive="${3}"
    if [[ -d "${src}" && "${recursive}" == "true" ]]; then
        find "${src}" -type f | while read -r file; do
            symlink "${file}" "${dst}/${file#${src}/}"
        done
    else
        mkdir -p "$(dirname "${dst}")"
        ln -sfn "${src}" "${dst}"
    fi
}

function hardlink() {
    mkdir -p "$(dirname "${2}")"
    ln -f "${1}" "${2}"
}

function system_install_macos() {
    if ! command -v brew > /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Brew is not on the PATH until the profile sets it up
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    brew bundle install --file "${ROOT}/Brewfile"
}

function curl_install_pixi() {
    export PIXI_NO_PATH_UPDATE=1
    curl -fsSL https://pixi.sh/install.sh | sh
}

function system_install_debian() {
    sudo apt-get update
    grep -v -e '^\s*#' -e '^\s*$' "${ROOT}/misc/apt.txt" | xargs sudo apt-get install --yes
}

function system_install() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        system_install_macos
    elif command -v apt-get > /dev/null; then
        system_install_debian
        curl_install_pixi
    fi
}

function install_dotfiles() {
    # shellcheck source=shell/profile
    source "${ROOT}/shell/profile"
    # shellcheck source=shell/isolation.sh
    source "${ROOT}/shell/isolation.sh"
    export_tool_storage_env "${XDG_CACHE_HOME}" "${XDG_CONFIG_HOME}" "${XDG_DATA_HOME}"
    export PATH="${PIXI_HOME}/bin:${PATH}"
    local conf="${XDG_CONFIG_HOME:-${HOME}/.config}"

    system_install
    bash "${ROOT}/misc/pixi-install.sh"

    # Use recursive=true for shared bin directory
    symlink "${ROOT}/bin" "${HOME}/.local/bin" "true"

    for d in shell nvim tmux tmuxp git misc; do symlink "${ROOT}/${d}" "${conf}/${d}"; done

    symlink "${conf}/shell/profile"    "${HOME}/.profile"
    symlink "${conf}/shell/profile"    "${HOME}/.zprofile"
    symlink "${conf}/shell/bashrc"     "${HOME}/.bashrc"
    symlink "${conf}/shell/zshrc"      "${HOME}/.zshrc"
    symlink "${conf}/tmux/tmux.conf"   "${HOME}/.tmux.conf"
    symlink "${conf}/misc/inputrc"     "${HOME}/.inputrc"
    symlink "${conf}/misc/editrc"      "${HOME}/.editrc"
    symlink "${conf}/misc/condarc"     "${HOME}/.condarc"

    symlink "${ROOT}/misc/alacritty.toml"  "${conf}/alacritty/alacritty.toml"
    symlink "${ROOT}/misc/ipython"         "${conf}/ipython"
    symlink "${ROOT}/misc/clangd.yaml"     "${conf}/clangd/config.yaml"
    hardlink "${ROOT}/misc/karabiner.json" "${conf}/karabiner/karabiner.json"

    # pckr has no completion event, but its actions take a callback as last argument
    nvim -n --headless +'lua require("pckr.actions").sync(nil, nil, function() vim.cmd("qa!") end)'
}

install_dotfiles
