function pngtex -d "turns latex into png"
    set tmpdir (mktemp -d)
    set olddir (pwd)
    set output_cmd "kitty +kitten icat"

    if not set -q KITTY_WINDOW_ID
        set output_cmd "printf 'set command with --cmd\nset `--cmd true` to suppress this message\n' # "
    end

    function help_msg
        echo "usage: pngtex [-hc] -- <latex formula>"
        echo ""
        echo "    -c, --cmd string      sets the command invoked to save the image. default: 'kitty +kitten icat'"
        echo "    -s, --save string     saves the file to the specified location"
        echo "    -h, --help            shows this message"
        echo "    -I, --replace pattern replaces pattern with the output file when showing the image"
    end

    if not argparse 'h/help' 'c/cmd=' 's/save=' 'I/replace=' -- $argv
        help_msg >&2
        return 1
    end

    if set -q _flag_help
        help_msg
        return
    end

    if set -q _flag_cmd
        set output_cmd $_flag_cmd
    end

    if set -q _flag_save
        set save_dir (realpath $_flag_save)
    else if set -q PNGTEX_SAVEDIR
        set save_dir (realpath $PNGTEX_SAVEDIR)
    end

    if set -q _flag_replace
        set replace $_flag_replace
    end

    function make_cmd -a file output_cmd replacement
        if [ -n "$replacement" ]
            set -l escaped (echo $replacement | sed 's|/|\\\\/|g')
            echo "$output_cmd" | sed "s/$escaped/$(echo $file | sed 's|/|\\\\/|g')/g"
            return
        end
        echo "$output_cmd $file"
    end


    function prompt
        set_color green
        echo -n enter latex here
        set_color normal
        echo ": "
    end

    if not set -q argv[1]
        while read --prompt prompt line
            set argv $argv $line
        end
    end

    function main --argument output_cmd save_dir replace cwd
        echo "
        \\documentclass[border={10pt 10pt 10pt 10pt}]{standalone}
        \\usepackage{hyde}
        \\begin{document}
        \$$argv[5..]\$
        \\end{document}
        " > tmp.tex
        or return $status

        yes q | env TEXINPUTS=".:$HOME/.local/share/:$TEXINPUTS" pdflatex tmp.tex >/dev/null
        set -l st $status
        if not [ "$st" = 0 ]
            set_color -r red
            cat tmp.log | egrep -A1 '^!' | head -n 30 >&2 
            set_color normal
            return $st
        end

        convert -density 300 tmp.pdf -quality 90 -colorspace RGB -background white -alpha remove -alpha off output.png
        or return $status


        set -l output "output.png"
        if [ -n "$save_dir" ]
            set output  "$save_dir/$(date +%s).png"
            cp "output.png" "$output"
            or return $status
        end

        set -l cmd (make_cmd $output $output_cmd $replace)

        command $SHELL -c "cd '$cwd'; $cmd"
        or return $status
    end


    cd "$tmpdir"
    main "$output_cmd" "$save_dir" "$replace" "$olddir" $argv
    set st $status
    cd "$olddir"
    command rm -r "$tmpdir"
    return $st
end
