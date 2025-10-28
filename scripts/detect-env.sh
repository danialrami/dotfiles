#!/bin/bash

set -euo pipefail

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "darwin"
    else
        echo "linux"
    fi
}

detect_distro() {
    local os
    os=$(detect_os)
    
    if [[ "$os" == "darwin" ]]; then
        echo "macos"
        return 0
    fi
    
    if [[ ! -f /etc/os-release ]]; then
        echo "unknown"
        return 1
    fi
    
    . /etc/os-release
    
    case "${ID:-unknown}" in
        arch)
            echo "arch"
            ;;
        ubuntu)
            echo "ubuntu"
            ;;
        fedora)
            echo "fedora"
            ;;
        debian)
            echo "debian"
            ;;
        *)
            echo "${ID:-unknown}"
            ;;
    esac
}

detect_hostname() {
    hostname -s 2>/dev/null || hostname || echo "unknown"
}

export_env_vars() {
    export DOTFILES_OS
    export DOTFILES_DISTRO
    export DOTFILES_HOSTNAME
}

main() {
    DOTFILES_OS=$(detect_os)
    DOTFILES_DISTRO=$(detect_distro)
    DOTFILES_HOSTNAME=$(detect_hostname)
    
    export_env_vars
    
    if [[ "${DOTFILES_DEBUG:-0}" == "1" ]]; then
        echo "[dotfiles-env] OS: $DOTFILES_OS, Distro: $DOTFILES_DISTRO, Hostname: $DOTFILES_HOSTNAME" >&2
    fi
}

main "$@"
