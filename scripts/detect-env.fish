#!/usr/bin/env fish

function detect_os
    switch (uname -s)
        case Darwin
            echo "darwin"
        case Linux
            echo "linux"
        case '*'
            echo (uname -s | tr '[:upper:]' '[:lower:]')
    end
end

function detect_distro
    set -l os (detect_os)
    
    if test "$os" = "darwin"
        echo "macos"
        return 0
    end
    
    if not test -f /etc/os-release
        echo "unknown"
        return 1
    end
    
    set -l distro_id (grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
    
    switch $distro_id
        case arch
            echo "arch"
        case ubuntu
            echo "ubuntu"
        case fedora
            echo "fedora"
        case debian
            echo "debian"
        case centos
            echo "centos"
        case rhel
            echo "rhel"
        case '*'
            echo $distro_id
    end
end

function detect_hostname
    hostname -s 2>/dev/null || hostname || echo "unknown"
end

set -gx DOTFILES_OS (detect_os)
set -gx DOTFILES_DISTRO (detect_distro)
set -gx DOTFILES_HOSTNAME (detect_hostname)

if test "$DOTFILES_DEBUG" = "1"
    echo "[dotfiles-env] OS: $DOTFILES_OS, Distro: $DOTFILES_DISTRO, Hostname: $DOTFILES_HOSTNAME" >&2
end
