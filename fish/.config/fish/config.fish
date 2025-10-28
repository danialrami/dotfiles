# ~/.config/fish/config.fish

# Initialize ARM Homebrew - MUST BE FIRST
if test -d /opt/homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# Initialize mise (ARM version)
if command -v mise > /dev/null
    /opt/homebrew/bin/mise activate fish | source
end

# Environment variables
set -gx EZA_ICONS_AUTO 1
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Python version consistency - ensure all Python tools use the same version
# This fixes the version mismatch between python3 and pip
set -gx PYTHON_VERSION "3.13"

# Path modifications (fish uses lists, not colon-separated strings)
set -gx PATH $HOME/.tmuxifier/bin $PATH
set -gx PATH $HOME/bin $PATH

# Source shared configurations (converted to fish)
source ~/.dotfiles/shared/go_env.fish
source ~/.dotfiles/shared/secure_env.fish

# Python aliases to ensure version consistency
# Strategy: Find the actual python3 being used and make everything point to it
set -l python_cmd (command -v python3)
if test -n "$python_cmd"
    # Use whatever python3 is actually being used (likely from your PATH)
    alias python "$python_cmd"
    alias python3 "$python_cmd"
    alias pip "$python_cmd -m pip"
    alias pip3 "$python_cmd -m pip"
    
    # Also try to set a specific version alias if available
    if command -v python3.13 > /dev/null
        alias python313 "python3.13"
    end
else
    echo "⚠️ Warning: No python3 found in PATH"
end

# Function to show what Python version is actually being used
function show_python_info
    echo "🐍 Current Python Setup:"
    echo "  Active python3: "(command -v python3)
    echo "  Version: "(python3 --version 2>/dev/null || echo "Not found")
    echo "  pip location: "(python3 -m pip --version 2>/dev/null | grep -o '/[^[:space:]]*' | head -1)
    echo "  PATH python3: "(which python3)
end

# Function to check Python version consistency
function check_python_version
    echo "🐍 Python Version Check:"
    echo "  python:  "(python --version 2>/dev/null || echo "Not found")
    echo "  python3: "(python3 --version 2>/dev/null || echo "Not found")
    echo "  pip:     "(pip --version 2>/dev/null || echo "Not found")
    echo "  pip3:    "(pip3 --version 2>/dev/null || echo "Not found")
    echo ""
    echo "All should show the same version for consistency."
end

# Function to check architecture
function check_arch
    echo "🏗️ Architecture Check:"
    echo "  uname -m: "(uname -m)
    echo "  arch: "(arch)
    echo "  fish: "(file (command -v fish))
    echo ""
    echo "Should show arm64 for native Apple Silicon"
end

# Function to install Python packages for the correct version
function install_python_package
    if test (count $argv) -eq 0
        echo "Usage: install_python_package <package_name>"
        return 1
    end
    
    echo "Installing $argv[1] for "(python3 --version)"..."
    python3 -m pip install --user $argv[1]
end

# Audio development shortcuts (since you work with audio tools)
if command -v supercollider > /dev/null
    alias sc "supercollider"
    alias sclang "/Applications/SuperCollider.app/Contents/MacOS/sclang"
end

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

# Quick script execution aliases (functions are auto-loaded from functions/)
alias run "run_script"
alias x "run_script"

# Audio workflow aliases
# alias audio "audio_session"
# alias audio_dev "audio_session dev"
# alias audio_mix "audio_session mixing"

# vscodium not needed since I added a symlink
# alias codium "/Applications/VSCodium.app/Contents/Resources/app/bin/codium"

# Echo Bridge manual build alias for convenience
if test -f "build_manual.py"
    alias build_manual "python3 build_manual.py"
    alias build "python3 build_manual.py"
end

kubectl completion fish | source

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/danielramirez/.lmstudio/bin
# End of LM Studio CLI section

# Optional: Show architecture on startup (remove if you don't want it)
# echo "🏗️ Running on: "(uname -m)" architecture"
