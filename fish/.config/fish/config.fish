# ~/.config/fish/config.fish

# Environment variables
set -gx EZA_ICONS_AUTO 1
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Path modifications (fish uses lists, not colon-separated strings)
set -gx PATH $HOME/.tmuxifier/bin $PATH
set -gx PATH /usr/local/opt/util-linux/bin $PATH
set -gx PATH /usr/local/opt/util-linux/sbin $PATH

# Source shared configurations (converted to fish)
source ~/.dotfiles/shared/go_env.fish
source ~/.dotfiles/shared/secure_env.fish

# Tool initializations
starship init fish | source
zoxide init --cmd cd fish | source
tmuxifier init - fish | source
thefuck --alias | source

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

# Audio development shortcuts (since you work with audio tools)
if command -v supercollider > /dev/null
    alias sc "supercollider"
    alias sclang "/Applications/SuperCollider.app/Contents/MacOS/sclang"
end

# Quick script execution aliases (functions are auto-loaded from functions/)
alias run "run_script"
alias x "run_script"

# Audio workflow aliases
# alias audio "audio_session"
# alias audio_dev "audio_session dev"
# alias audio_mix "audio_session mixing"

alias codium "/Applications/VSCodium.app/Contents/Resources/app/bin/codium"