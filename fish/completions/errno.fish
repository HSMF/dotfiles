complete -c errno --short 'l' --long "list"         -d "List all errno values"
complete -c errno --short 's' --long "search"   -r  -d "Search for errors whose description contains all the given words (case-insensitive)"
complete -c errno -a "$(errno -l | awk '{print $1}')" -f

