# ~/.config/fish/functions/audio_session.fish
function audio_session --description "Setup audio development environment"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: audio_session [session_name]"
        echo " Setup audio development environment with tmux"
        echo ""
        echo "Arguments:"
        echo " session_name Name for the tmux session (default: audio)"
        echo ""
        echo "Features:"
        echo " - Creates organized tmux session for audio work"
        echo " - Sets up windows for different audio tools"
        echo " - Checks for JACK daemon"
        echo " - Launches in audio project directory"
        echo ""
        echo "Windows created:"
        echo " 1. main      - General terminal in audio projects"
        echo " 2. sc        - SuperCollider session"
        echo " 3. daw       - For launching DAW or audio tools"
        echo " 4. monitor   - System monitoring (htop, etc.)"
        return 0
    end

    set session_name (test -n "$argv[1]"; and echo "$argv[1]"; or echo "audio")
    set audio_dir "$HOME/Audio/Projects"
    
    # Create audio directory if it doesn't exist
    if not test -d "$audio_dir"
        mkdir -p "$audio_dir"
        echo "Created audio projects directory: $audio_dir"
    end
    
    # Check if session already exists
    if tmux has-session -t "$session_name" 2>/dev/null
        echo "🎵 Attaching to existing audio session: $session_name"
        tmux attach-session -t "$session_name"
        return 0
    end
    
    echo "🎵 Creating new audio session: $session_name"
    
    # Create main session
    tmux new-session -d -s "$session_name" -c "$audio_dir"
    tmux rename-window -t "$session_name:1" "main"
    
    # SuperCollider window
    tmux new-window -t "$session_name" -n "sc" -c "$audio_dir"
    tmux send-keys -t "$session_name:sc" "echo 'SuperCollider workspace ready. Use: sclang or nvim for scnvim'" Enter
    
    # DAW/Tools window
    tmux new-window -t "$session_name" -n "daw" -c "$audio_dir"
    tmux send-keys -t "$session_name:daw" "echo 'Audio tools workspace ready'" Enter
    
    # Monitoring window
    tmux new-window -t "$session_name" -n "monitor"
    tmux send-keys -t "$session_name:monitor" "htop" Enter
    
    # Go back to main window
    tmux select-window -t "$session_name:main"
    
    # Check for JACK
    if not pgrep -x "jackd" > /dev/null
        echo "💡 JACK daemon not running. You may want to start it for low-latency audio."
        tmux send-keys -t "$session_name:main" "echo 'JACK not running. Start with your preferred JACK setup.'" Enter
    else
        echo "✅ JACK daemon is running"
        tmux send-keys -t "$session_name:main" "echo 'JACK is running - ready for audio work!'" Enter
    end
    
    # Show some useful info
    tmux send-keys -t "$session_name:main" "echo 'Audio session ready! Windows: main, sc, daw, monitor'" Enter
    tmux send-keys -t "$session_name:main" "ls -la" Enter
    
    # Attach to the session
    tmux attach-session -t "$session_name"
end