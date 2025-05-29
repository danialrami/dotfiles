function kill_process --description "Interactively select and kill a process"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: kill_process"
        echo " Interactively select and kill a process"
        echo ""
        echo "Features:"
        echo " - Lists processes using procs"
        echo " - Interactive selection with fzf"
        echo " - Kills selected process"
        return 0
    end

    if not command -v procs > /dev/null; or not command -v fzf > /dev/null
        echo "Error: This function requires procs and fzf"
        return 1
    end

    set pid (procs | fzf --header-lines=1 | awk '{print $1}')

    if test -n "$pid"
        echo "Killing process $pid..."
        kill "$pid"
    end
end
