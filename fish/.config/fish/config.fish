# ~/.config/fish/config.fish - Arch Linux (siku) version

# Environment variables
set -gx EZA_ICONS_AUTO 1
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Path modifications (fish uses lists, not colon-separated strings)
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH

# Arch-specific paths (different from macOS)
if test -d /usr/bin
    set -gx PATH /usr/bin $PATH
end

# Only source files that exist on this system
if test -f ~/.dotfiles/shared/secure_env.fish
    source ~/.dotfiles/shared/secure_env.fish
end

# Skip macOS-specific go_env for now (we'll handle Go separately)
source ~/.dotfiles/shared/go_env_arch.fish

# Tool initializations - only if commands exist
if command -v starship > /dev/null
    starship init fish | source
end

if command -v zoxide > /dev/null
    zoxide init --cmd cd fish | source
end

if command -v tmuxifier > /dev/null
    set -gx PATH $HOME/.tmuxifier/bin $PATH
    tmuxifier init - fish | source
end

if command -v thefuck > /dev/null
    thefuck --alias | source
end

# Conditional aliases for Rust tools
if command -v bat > /dev/null
    alias cat "bat --style=auto"
    alias ccat "bat --style=plain"
end

if command -v fd > /dev/null
    alias find "fd"
end

if command -v rg > /dev/null
    alias grep "rg"
end

if command -v dust > /dev/null
    alias du "dust"
end

if command -v eza > /dev/null
    alias ls "eza --icons=always --group-directories-first"
    alias ll "eza --icons=always --group-directories-first -l"
    alias la "eza --icons=always --group-directories-first -la"
else
    # Fallback to regular ls with some color
    alias ls "ls --color=auto --group-directories-first"
    alias ll "ls -l --color=auto --group-directories-first"
    alias la "ls -la --color=auto --group-directories-first"
end

if command -v delta > /dev/null
    # Configure git to use delta
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.light false
end

if command -v procs > /dev/null
    alias ps "procs"
end

if command -v sd > /dev/null
    alias sed "sd"
end

# Arch-specific aliases
if command -v yay > /dev/null
    alias install "yay -S"
    alias search "yay -Ss"
    alias update "yay -Syu"
    alias remove "yay -R"
end

if command -v bandwhich > /dev/null
    alias netmon "sudo bandwhich"
end

if command -v diskonaut > /dev/null
    alias diskusage "diskonaut"
end

if command -v dua > /dev/null
    alias dua "dua interactive"
end

if command -v just > /dev/null
    alias j "just"
end

# Yazi file manager with directory changing capability
if command -v yazi > /dev/null
    alias fm "y"
    alias files "y"
end

# Audio development shortcuts (Arch paths)
if command -v sclang > /dev/null
    alias sc "sclang"
    alias scstart "sclang"
end

# SuperCollider is likely at /usr/bin/sclang on Arch
if test -f /usr/bin/sclang
    set -gx SC_PATH /usr/bin/sclang
end

# Quick script execution aliases (functions are auto-loaded from functions/)
alias run "run_script"
alias x "run_script"

# System management shortcuts
alias syslog "journalctl -f"
alias services "systemctl --user list-units"
alias restart_audio "systemctl --user restart pipewire pipewire-pulse"
