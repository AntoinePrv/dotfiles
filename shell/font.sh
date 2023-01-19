#!/usr/bin/env bash

FONT_DIR="${XDG_DATA_HOME}/fonts"

mkdir -p "${FONT_DIR}"
readonly tmp_dir="$(mktemp -d)"
cd "${tmp_dir}"
curl -sL -O https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/FiraCode.zip
unzip *.zip > /dev/null
mv *.ttf "${FONT_DIR}"
