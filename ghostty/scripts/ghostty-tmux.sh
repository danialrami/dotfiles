#!/bin/bash

# Find tmux executable
TMUX_CMD=""
for path in "/usr/local/bin/tmux" "/opt/homebrew/bin/tmux" "$(command -v tmux)"; do
    if [ -x "$path" ]; then
        TMUX_CMD="$path"
        break
    fi
done

# Exit if tmux not found
if [ -z "$TMUX_CMD" ]; then
    echo "Error: tmux not found"
    exit 1
fi

# Find the next available session number
SESSION_NUM=1
while $TMUX_CMD has-session -t "ghostty-$SESSION_NUM" 2>/dev/null; do
    ((SESSION_NUM++))
done

SESSION_NAME="ghostty-$SESSION_NUM"

# Create new numbered session
$TMUX_CMD new-session -s "$SESSION_NAME"