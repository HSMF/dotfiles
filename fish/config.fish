# bootstrap path
set -gx PATH (~/.cargo/bin/aliaser -s fish path ~/.config/path) $PATH
aliaser -s fish alias  ~/.config/aliases.toml | source
aliaser -s fish env ~/.config/envs.toml | source

# fish only aliases
aliaser -s fish alias ~/.config/fish/fish-aliases.toml | source

set -gx PNGTEX_SAVEDIR (mktemp -d)

function fish_greeting
    source ~/.config/fish/abbrs.fish
    source ~/.config/fish/bindings.fish
    # pypy3 $HOME/opt/hyde-source/welcome_message.py
    pfetch

    # task summary

    fish_config theme choose Nord
    # shell prompt

    starship init fish | source
end


# opam configuration
eval (opam env)
zoxide init fish | source

# pnpm
set -gx PNPM_HOME "/home/hyde/.local/state/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/miniconda3/bin/conda
    eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/opt/miniconda3/etc/fish/conf.d/conda.fish"
        . "/opt/miniconda3/etc/fish/conf.d/conda.fish"
    else
        # set -x PATH "/opt/miniconda3/bin" 
    end
end
# <<< conda initialize <<<

