# ~/.dotfiles/shared/go_env.fish
# macOS-specific Go environment (uses Homebrew)

if command -v brew > /dev/null
    set -gx GOROOT (brew --prefix go)/libexec
    set -gx GOPATH $HOME/go
    set -gx PATH $GOPATH/bin $GOROOT/bin $HOME/.local/bin $PATH
else
    # Fallback for systems without Homebrew
    set -gx GOPATH $HOME/go
    set -gx PATH $GOPATH/bin $HOME/.local/bin $PATH
end
