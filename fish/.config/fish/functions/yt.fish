# ~/.config/fish/functions/yt.fish
function yt --description "Extract transcript from YouTube video using fabric"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: yt <video_link>"
        echo " Extract transcript from YouTube video using fabric"
        echo ""
        echo "Arguments:"
        echo " video_link YouTube video URL"
        echo ""
        echo "Example:"
        echo " yt https://www.youtube.com/watch?v=..."
        return 0
    end

    if not command -v fabric > /dev/null
        echo "Error: This function requires fabric"
        return 1
    end

    set video_link "$argv[1]"
    fabric -y "$video_link" --transcript
end
