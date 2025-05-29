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

SESSION_NAME="ghostty-main"

# Simple approach: try to attach, create if it fails
$TMUX_CMD attach-session -t "$SESSION_NAME" 2>/dev/null || \
$TMUX_CMD new-session -s "$SESSION_NAME"
