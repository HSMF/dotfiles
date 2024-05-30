function done --description 'display a message when the previous command has finished'
terminal-notifier -title "done with $(status current-command)" -message "$(status current-commandline)"
end
