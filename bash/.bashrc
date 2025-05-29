# ~/.dotfiles/bash/.bashrc

# Load environment variables first (usually fastest)
source ${HOME}/.ghcup/env
source ~/.dotfiles/shared/fabric_aliases.sh
source ~/.dotfiles/shared/go_env.sh
source ~/.dotfiles/shared/secure_env.sh

# Basic exports (fast)
export EZA_ICONS_AUTO=1
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.tmuxifier/bin:$PATH"
export PATH="/usr/local/opt/util-linux/bin:$PATH"
export PATH="/usr/local/opt/util-linux/sbin:$PATH"

# Aliases (fast)
alias ls="eza --icons=always --group-directories-first"
alias ll="eza --icons=always --group-directories-first -l"
alias la="eza --icons=always --group-directories-first -la"
alias cv="z"

# Tool initializations (now safe for VSCode)
eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(tmuxifier init -)"
eval "$(thefuck --alias)"
