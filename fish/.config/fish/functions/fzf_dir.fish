# ~/.config/fish/functions/fzf_dir.fish
function fzf_dir --description "Navigate to directories using fzf with tree preview"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: fzf_dir"
        echo " Navigate to directories using fzf with tree preview"
        echo ""
        echo "Features:"
        echo " - Searches for directories recursively (excluding .git)"
        echo " - Shows directory tree preview using eza"
        echo " - Changes to selected directory"
        return 0
    end

    if not command -v fd > /dev/null; or not command -v fzf > /dev/null; or not command -v eza > /dev/null
        echo "Error: This function requires fd, fzf, and eza"
        return 1
    end

    set dir (fd --type d --hidden --follow --exclude .git | fzf --preview 'eza --tree --level=2 --icons {}')

    if test -n "$dir"
        cd "$dir"
    end
end
