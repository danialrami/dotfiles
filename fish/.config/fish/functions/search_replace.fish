function search_replace --description "Search and replace text across multiple files"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: search_replace <search_pattern> <replacement> [file_pattern]"
        echo " Search and replace text across multiple files"
        echo ""
        echo "Arguments:"
        echo " search_pattern Pattern to search for"
        echo " replacement Text to replace with"
        echo " file_pattern File pattern to match (default: *)"
        echo ""
        echo "Example:"
        echo " search_replace 'old_text' 'new_text' '*.txt'"
        return 0
    end

    if not command -v rg > /dev/null; or not command -v sd > /dev/null
        echo "Error: This function requires rg (ripgrep) and sd"
        return 1
    end

    if test (count $argv) -lt 2
        echo "Usage: search_replace <search_pattern> <replacement> [file_pattern]"
        return 1
    end

    set search "$argv[1]"
    set replace "$argv[2]"
    set pattern (test -n "$argv[3]"; and echo "$argv[3]"; or echo "*")

    echo "Searching for '$search' in $pattern files..."
    rg "$search" --files-with-matches "$pattern" | while read -r file
        echo "Processing: $file"
        sd "$search" "$replace" "$file"
    end
end
