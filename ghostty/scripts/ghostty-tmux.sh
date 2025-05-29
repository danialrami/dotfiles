#!/bin/bash

SESSION_NAME="ghostty-main"

# Check if the session already exists
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? -eq 0 ]; then
    # If the session exists, reattach to it
    tmux attach-session -t $SESSION_NAME
else
    # If the session doesn't exist, start a new one with some default windows
    tmux new-session -s $SESSION_NAME -d -c ~
    
    # Create additional windows for common tasks
    tmux new-window -t $SESSION_NAME -n "projects" -c ~/Projects
    tmux new-window -t $SESSION_NAME -n "dotfiles" -c ~/.dotfiles
    
    # Go back to the first window
    tmux select-window -t $SESSION_NAME:1
    
    # Attach to the session
    tmux attach-session -t $SESSION_NAME
fi
