#!/bin/bash

set -euo pipefail

source ~/.dotfiles/scripts/detect-env.sh

if [[ "$DOTFILES_DISTRO" == "macos" ]]; then
    STARSHIP_CONFIG="$HOME/.config/starship/starship.darwin.toml"
elif [[ "$DOTFILES_DISTRO" == "arch" ]]; then
    STARSHIP_CONFIG="$HOME/.config/starship/starship.arch.toml"
else
    STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
fi

if [[ ! -f "$STARSHIP_CONFIG" ]]; then
    STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
fi

export STARSHIP_CONFIG

if [[ "${DOTFILES_DEBUG:-0}" == "1" ]]; then
    echo "[dotfiles] Using starship config: $STARSHIP_CONFIG" >&2
fi
