# ~/.config/fish/functions/fzf_file.fish
function fzf_file --description "Find and edit files using fzf with bat preview"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: fzf_file"
        echo " Find and edit files using fzf with bat preview"
        echo ""
        echo "Features:"
        echo " - Searches for files recursively (excluding .git)"
        echo " - Shows file preview using bat"
        echo " - Opens selected file in \$EDITOR (default: nano)"
        return 0
    end

    if not command -v fd > /dev/null; or not command -v fzf > /dev/null; or not command -v bat > /dev/null
        echo "Error: This function requires fd, fzf, and bat"
        return 1
    end

    set file (fd --type f --hidden --follow --exclude .git | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')

    if test -n "$file"
        eval $EDITOR "$file"
    end
end
