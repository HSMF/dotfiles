complete -c sioyek  -l new-window                                   -d 'Open the file in a new window but within the same sioyek instance.'
complete -c sioyek  -l reuse-window                                 -d "Force sioyek to reuse the current window even when should_launch_new_window is set." 
complete -c sioyek  -l nofocus                                      -d "Do not bring the sioyek instance to foreground."
complete -c sioyek  -l version                                      -d "Print sioyek version."
complete -c sioyek  -l page -r                                      -d "Which page to open."
complete -c sioyek  -l focus-text -r                                -d "Set a visual mark on line including <text>."
complete -c sioyek  -l focus-text-page -r                           -d "Specifies the page which is used for focus-text"
complete -c sioyek  -l inverse-search -r                            -d "The command to execute when performing inverse search. In <command>, %1 is filled with the file name and %2 is filled with the line number."
complete -c sioyek  -l execute-command -r                           -d "The command to execute on running instance of sioyek"
complete -c sioyek  -l execute-command-data -r                      -d "Optional data for execute-command command"
complete -c sioyek  -l forward-search-file -a __fish_complete_path  -d "Perform forward search on file <file>. You must also include --forward-search-line to specify the line"
complete -c sioyek  -l forward-search-line -r                       -d "Perform forward search on line <line>. You must also include --forward-search-file to specify the file"
complete -c sioyek  -l forward-search-column -r                     -d "Perform forward search on column <column>. You must also include --forward-search-file to specify the file"
complete -c sioyek  -l zoom -r                                      -d "Set zoom level to <zoom>."
complete -c sioyek  -l xloc -r                                      -d "Set x position within page to <xloc>."
complete -c sioyek  -l yloc -r                                      -d "Set y position within page to <yloc>."
complete -c sioyek  -l shared-database-path -a __fish_complete_path -d "Specify which file to use for shared data (bookmarks, highlights, etc.)"
complete -c sioyek  -s h -l help                                    -d "Displays help on commandline options."
complete -c sioyek  -l help-all                                     -d "Displays help including Qt specific options."
