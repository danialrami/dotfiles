#!/usr/bin/env fish

source ~/.dotfiles/scripts/detect-env.fish

if test "$DOTFILES_DISTRO" = "macos"
    set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship.darwin.toml"
else if test "$DOTFILES_DISTRO" = "arch"
    set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship.arch.toml"
else
    set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
end

if not test -f "$STARSHIP_CONFIG"
    set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
end

if test "$DOTFILES_DEBUG" = "1"
    echo "[dotfiles] Using starship config: $STARSHIP_CONFIG" >&2
end
