function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

function all_last_arguments
    echo $history[1] | tr ' ' '\n' | tail -n +2 | tr '\n' ' '
end
abbr -a '!*' --position anywhere --function all_last_arguments


function last_argument
    echo $history[1] | tr ' ' '\n' | tail -n1
end
abbr -a '!$' --position anywhere --function last_argument


abbr -a ... --position anywhere ../..
abbr -a .... --position anywhere ../../..
abbr -a ..... --position anywhere ../../../..
