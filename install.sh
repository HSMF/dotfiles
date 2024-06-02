#!/bin/bash

set -ex

config="$HOME/.config"
share="$HOME/.local/share"
opt="$HOME/opt"

mkdir -p "$config"
mkdir -p "$share"
mkdir -p "$opt"

ln -s "$(pwd)/fish" "$config/fish"
ln -s "$(pwd)/tmux" "$config/tmux"

ln -s "$(pwd)/latex/hyde.sty" "$share/hyde.sty"

git clone "git@github.com:HSMF/nvim-config.git" "$config/nvim"

cargo install --path ./project-name
cargo install --path ./aliaser

ln -s "$(pwd)/bin" "$opt/bin"
ln -s "$(pwd)/aliases.toml" "$config/aliases-base.toml"
ln -s "$(pwd)/envs.toml" "$config/envs-base.toml"
