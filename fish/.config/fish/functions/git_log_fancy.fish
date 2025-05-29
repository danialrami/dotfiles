function git_log_fancy --description "Interactive git log browser with commit preview"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: git_log_fancy"
        echo " Interactive git log browser with commit preview"
        echo ""
        echo "Features:"
        echo " - Shows git log in graph format"
        echo " - Interactive selection with fzf"
        echo " - Preview commit details using delta"
        return 0
    end

    if not command -v git > /dev/null; or not command -v fzf > /dev/null; or not command -v delta > /dev/null
        echo "Error: This function requires git, fzf, and delta"
        return 1
    end

    git log --oneline --graph --color=always | fzf --ansi --preview 'git show --color=always {1} | delta'
end
