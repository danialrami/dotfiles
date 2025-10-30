#!/usr/bin/env fish

# Set default editor for OpenCode and other tools
set -gx EDITOR "vscodium -r"

for conf_file in ~/.config/fish/conf.d/*.fish
    source $conf_file
end

set -l python_cmd (command -v python3)
if test -n "$python_cmd"
    alias python "$python_cmd"
    alias python3 "$python_cmd"
    alias pip "$python_cmd -m pip"
    alias pip3 "$python_cmd -m pip"
    
    if command -v python3.13 > /dev/null
        alias python313 "python3.13"
    end
else
    echo "⚠️ Warning: No python3 found in PATH"
end

function show_python_info
    echo "🐍 Current Python Setup:"
    echo "  python3: $(command -v python3)"
    echo "  Version: $(python3 --version 2>&1)"
    echo "  pip3: $(command -v pip3)"
    echo "  pip version: $(pip3 --version 2>&1)"
end

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

if command -v yazi > /dev/null
    alias fm "y"
    alias files "y"
end

alias run "run_script"
alias x "run_script"

if test -f "build_manual.py"
    alias build_manual "python3 build_manual.py"
    alias build "python3 build_manual.py"
end
