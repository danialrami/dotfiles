#!/usr/bin/env fish

starship init fish | source
zoxide init --cmd cd fish | source
tmuxifier init - fish | source
thefuck --alias | source
kubectl completion fish | source

set -gx PATH $PATH /Users/danielramirez/.lmstudio/bin
