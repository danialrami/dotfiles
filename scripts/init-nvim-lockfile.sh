#!/bin/bash

set -euo pipefail

source ~/.dotfiles/scripts/detect-env.sh

NVIM_DIR="${HOME}/.config/nvim"
DOTFILES_NVIM_DIR="${HOME}/.dotfiles/neovim/.config/nvim"

if [[ "$DOTFILES_DISTRO" == "macos" ]]; then
    LOCK_VARIANT="darwin"
elif [[ "$DOTFILES_DISTRO" == "arch" ]]; then
    LOCK_VARIANT="arch"
else
    LOCK_VARIANT="darwin"
fi

SOURCE_LOCK="${DOTFILES_NVIM_DIR}/lazy-lock.${LOCK_VARIANT}.json"
TARGET_LOCK="${NVIM_DIR}/lazy-lock.json"

if [[ ! -f "$SOURCE_LOCK" ]]; then
    echo "[dotfiles] Warning: Lock file not found: $SOURCE_LOCK" >&2
    echo "[dotfiles] Using generic lazy-lock.json" >&2
    SOURCE_LOCK="${DOTFILES_NVIM_DIR}/lazy-lock.json"
fi

if [[ ! -d "$NVIM_DIR" ]]; then
    mkdir -p "$NVIM_DIR"
fi

if [[ ! -L "$TARGET_LOCK" ]] && [[ ! -f "$TARGET_LOCK" ]]; then
    ln -s "$SOURCE_LOCK" "$TARGET_LOCK"
    if [[ "${DOTFILES_DEBUG:-0}" == "1" ]]; then
        echo "[dotfiles] Created symlink: $TARGET_LOCK → $SOURCE_LOCK" >&2
    fi
elif [[ -f "$TARGET_LOCK" ]] && [[ ! -L "$TARGET_LOCK" ]]; then
    if [[ "${DOTFILES_DEBUG:-0}" == "1" ]]; then
        echo "[dotfiles] Note: $TARGET_LOCK is not a symlink (local file)" >&2
    fi
else
    if [[ "${DOTFILES_DEBUG:-0}" == "1" ]]; then
        echo "[dotfiles] Symlink exists: $TARGET_LOCK" >&2
    fi
fi
