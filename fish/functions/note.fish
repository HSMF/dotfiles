function note
    set -l tempfile "$HOME/Documents/notes/note.$(date +%s)"
    date >> $tempfile
    echo $argv >> $tempfile
end
