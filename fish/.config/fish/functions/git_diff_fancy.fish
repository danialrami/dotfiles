# ~/.config/fish/functions/git_diff_fancy.fish
function git_diff_fancy --description "Show git diff output using delta for enhanced formatting"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: git_diff_fancy [git diff arguments]"
        echo " Show git diff output using delta for enhanced formatting"
        echo ""
        echo "Arguments:"
        echo " All arguments are passed directly to 'git diff'"
        echo ""
        echo "Examples:"
        echo " git_diff_fancy # Show unstaged changes"
        echo " git_diff_fancy --staged # Show staged changes"
        echo " git_diff_fancy HEAD~1 # Compare with previous commit"
        return 0
    end

    if not command -v git > /dev/null; or not command -v delta > /dev/null
        echo "Error: This function requires git and delta"
        return 1
    end

    if test (count $argv) -eq 0
        git diff | delta
    else
        git diff $argv | delta
    end
end
