# ~/.config/fish/functions/project_stats.fish
function project_stats --description "Display project statistics and code metrics"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: project_stats [path]"
        echo " Display project statistics and code metrics"
        echo ""
        echo "Arguments:"
        echo " path Project directory (default: current directory)"
        echo ""
        echo "Shows:"
        echo " - Code statistics using tokei"
        echo " - File count by extension"
        echo " - Largest files in the project"
        echo ""
        echo "Example:"
        echo " project_stats ~/my_project"
        return 0
    end

    if not command -v tokei > /dev/null; or not command -v fd > /dev/null; or not command -v rg > /dev/null
        echo "Error: This function requires tokei, fd, and rg (ripgrep)"
        return 1
    end

    set path (test -n "$argv[1]"; and echo "$argv[1]"; or echo ".")

    echo "=== Code Statistics ==="
    tokei "$path"

    echo ""
    echo "=== File Count by Type ==="
    fd --type f . "$path" | rg '\.' | rg -o '\.[^.]*$' | sort | uniq -c | sort -nr

    echo ""
    echo "=== Largest Files ==="
    fd --type f . "$path" -x ls -la | sort -k5 -nr | head -10
end
