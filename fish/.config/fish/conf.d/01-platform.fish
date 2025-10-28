#!/usr/bin/env fish

if test "$DOTFILES_OS" = "darwin"
    if test -d /opt/homebrew
        eval "$(/opt/homebrew/bin/brew shellenv)"
    end

    if command -v mise > /dev/null
        /opt/homebrew/bin/mise activate fish | source
    end

    if command -v supercollider > /dev/null
        alias sc "supercollider"
        alias sclang "/Applications/SuperCollider.app/Contents/MacOS/sclang"
    end

else if test "$DOTFILES_DISTRO" = "arch"
    source ~/.dotfiles/shared/go_env_arch.fish
end
