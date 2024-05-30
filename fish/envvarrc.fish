set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx DBUS_SESSION_BUS_ADDRESS "unix:path=(launchctl getenv DBUS_LAUNCHD_SESSION_BUS_SOCKET)"

set -gx LESSHISTFILE "$HOME/.local/logs/lesshst"
set -gx MYSQL_HISTFILE "$HOME/.local/logs/mysql_history"
set -gx NODE_REPL_HISTORY "$HOME/.local/logs/node_repl_history"
set -gx TASKRC "$HOME/.config/taskrc"
set -gx ETH "$HOME/eth/2"
set -gx DOCIQ "$HOME/dociq/"

set CERT_PATH (python3 -m certifi)
set -gx SSL_CERT_FILE {$CERT_PATH}
set -gx REQUESTS_CA_BUNDLE {$CERT_PATH}

set COWPATH "/usr/local/share/cows"
set -gx COWPATH "$COWPATH:$HOME/.cowsay/cowfiles"

set -gx NVIM_LISTEN_ADDRESS "{$TMPDIR}nvim-address"

set -gx PYTHONSTARTUP ~/.config/python/startup.py
set -gx PSQL_HISTORY ~/.local/logs/psqlhistory

set -gx FZF_CTRL_R_OPTS " --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"


set -gx GPG_TTY $(tty)
set -gx CLICOLOR 1
set -gx LSCOLORS "GxFxBxDxCxegedabagaced"


set -gx EDITOR nvim
