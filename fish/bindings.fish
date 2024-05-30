function edit_cmd --description 'Edit cmdline in $EDITOR'
    set -l f (mktemp $TMPDIR/fish.cmd.XXXXXXXX)
    set -l p (commandline -C)
    set -q EDITOR; or set -l EDITOR vim
    commandline -b > $f
    eval "$EDITOR -c 'set ft=fish' $f"
    commandline -r (more $f)
    commandline -C $p
    /bin/rm $f
end

bind \ck\ck edit_cmd
