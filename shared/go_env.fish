# ~/.dotfiles/shared/go_env.fish
set -gx GOROOT (brew --prefix go)/libexec
set -gx GOPATH $HOME/go
set -gx PATH $GOPATH/bin $GOROOT/bin $HOME/.local/bin $PATH
