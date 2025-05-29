function note --description "Create or browse markdown notes"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: note [note_name]"
        echo " Create or browse markdown notes"
        echo ""
        echo "Arguments:"
        echo " note_name Name of note to create/edit (without .md extension)"
        echo ""
        echo "Features:"
        echo " - No arguments: browse existing notes with preview"
        echo " - With argument: create/edit note"
        echo " - Notes stored in ~/Notes directory"
        echo ""
        echo "Examples:"
        echo " note # Browse notes"
        echo " note meeting-notes # Create/edit meeting-notes.md"
        return 0
    end

    set note_dir "$HOME/Notes"
    mkdir -p "$note_dir"

    if test (count $argv) -eq 0
        if not command -v fd > /dev/null; or not command -v fzf > /dev/null; or not command -v bat > /dev/null
            echo "Error: Browsing notes requires fd, fzf, and bat"
            return 1
        end

        # List and preview notes
        fd --type f . "$note_dir" | fzf --preview 'bat --style=numbers --color=always {}'
    else
        # Create/edit note
        set note_file "$note_dir/$argv[1].md"
        eval $EDITOR "$note_file"
    end
end
