function disk_analysis --description "Analyze disk usage for a directory"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: disk_analysis [path]"
        echo " Analyze disk usage for a directory"
        echo ""
        echo "Arguments:"
        echo " path Directory to analyze (default: current directory)"
        echo ""
        echo "Features:"
        echo " - Shows overview using dust"
        echo " - Opens interactive mode with diskonaut"
        echo ""
        echo "Example:"
        echo " disk_analysis ~/Downloads"
        return 0
    end

    if not command -v dust > /dev/null; or not command -v diskonaut > /dev/null
        echo "Error: This function requires dust and diskonaut"
        return 1
    end

    set path (test -n "$argv[1]"; and echo "$argv[1]"; or echo ".")

    echo "Analyzing disk usage for: $path"
    echo "=== Overview ==="
    dust "$path"

    echo ""
    echo "=== Interactive mode ==="
    echo "Press 'q' to quit diskonaut"
    diskonaut "$path"
end
