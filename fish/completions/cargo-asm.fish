function _bpaf_dynamic_completion
    set -l app (commandline --tokenize --current-process)[1]
    set -l tmpline --bpaf-complete-rev=1
    set tmpline $tmpline (commandline --tokenize --current-process)[2..-1]
    if test (commandline --current-process) != (string trim (commandline --current-process))
        set tmpline $tmpline ""
    end
    for opt in ($app $tmpline)
        echo -E "$opt"
    end
end

complete --no-files --command cargo-asm --arguments '(_bpaf_dynamic_completion)'
