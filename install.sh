#!/bin/bash

set -ex

config="$HOME/.config"
share="$HOME/.local/share"

mkdir -p "$config"
mkdir -p "$share"

ln -s "$(pwd)/fish" "$config/fish"
ln -s "$(pwd)/tmux" "$config/tmux"

ln -s "$(pwd)/latex/hyde.sty" "$share/hyde.sty"

git clone "git@github.com:HSMF/nvim-config.git" "$config/nvim"

