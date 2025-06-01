# ~/.dotfiles/shared/go_env_arch.fish
# Arch Linux specific Go environment

# Check if Go is installed via pacman
if command -v go > /dev/null
    # On Arch, Go is typically installed to /usr/bin/go
    set -gx GOROOT /usr/lib/go
    set -gx GOPATH $HOME/go
    set -gx PATH $GOPATH/bin $PATH
else
    echo "Go not installed. Install with: sudo pacman -S go"
end
