function mkdir -d "Create a directory and set CWD" -w mkdir
    command mkdir $argv
    if echo $argv | rg -q "/\$"
        if test $status = 0
            switch $argv[(count $argv)]
                case '-*'

                case '*'
                cd $argv[(count $argv)]
                return
            end
        end
    end
end

