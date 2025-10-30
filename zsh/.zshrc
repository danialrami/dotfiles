# ~/.dotfiles/zsh/.zshrc

# Set default editor for OpenCode and other tools
export EDITOR=nvim

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

__conda_setup="$('/Users/danielramirez/miniconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    [ -f "/Users/danielramirez/miniconda/etc/profile.d/conda.sh" ] && \
        . "/Users/danielramirez/miniconda/etc/profile.d/conda.sh" || \
        export PATH="/Users/danielramirez/miniconda/bin:$PATH"
fi
unset __conda_setup

source ${HOME}/.ghcup/env
source ~/.dotfiles/shared/fabric_aliases.sh
source ~/.dotfiles/shared/go_env.sh
source ~/.dotfiles/shared/secure_env.sh

#eval "$(starship init zsh)"
export EZA_ICONS_AUTO=1
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
alias ls="eza --icons=always --group-directories-first"
alias ll="eza --icons=always --group-directories-first -l"
alias la="eza --icons=always --group-directories-first -la"

eval "$(zoxide init zsh)"
alias cv="z"
export PATH="$HOME/.tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/danielramirez/.lmstudio/bin"
# End of LM Studio CLI section
