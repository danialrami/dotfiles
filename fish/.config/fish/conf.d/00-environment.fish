#!/usr/bin/env fish

source ~/.dotfiles/scripts/detect-env.sh

set -gx EZA_ICONS_AUTO 1
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

set -gx PYTHON_VERSION "3.13"

set -gx PATH $HOME/.tmuxifier/bin $PATH
set -gx PATH $HOME/bin $PATH

source ~/.dotfiles/shared/go_env.fish
source ~/.dotfiles/shared/secure_env.fish
