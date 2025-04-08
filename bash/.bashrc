# ~/.dotfiles/bash/.bashrc
source ${HOME}/.ghcup/env
source ~/.dotfiles/shared/fabric_aliases.sh
source ~/.dotfiles/shared/go_env.sh
source ~/.dotfiles/shared/secure_env.sh

eval "$(starship init bash)"
export EZA_ICONS_AUTO=1
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
alias ls="eza --icons=always --group-directories-first"
alias ll="eza --icons=always --group-directories-first -l"
alias la="eza --icons=always --group-directories-first -la"

eval "$(zoxide init bash)"
alias cv="z"

export PATH="$HOME/.tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"
eval "$(thefuck --alias)"
