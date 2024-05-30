#!/bin/bash
for f in $(find "$HOME/.local/share/tmux/resurrect" -maxdepth 1 -mindepth 1 | sort | grep "^.*\.txt$" | tac); do
    if [ -s "$f" ]; then
        echo "linking $f to last"
        ln -sf "$f" "$HOME/.local/share/tmux/resurrect/last"
        break
    else
        echo "$f is empty"
    fi
done
