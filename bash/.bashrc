# ~/.dotfiles/bash/.bashrc

# Load environment variables first (usually fastest)
source ${HOME}/.ghcup/env
source ~/.dotfiles/shared/fabric_aliases.sh
source ~/.dotfiles/shared/go_env.sh
source ~/.dotfiles/shared/secure_env.sh

# Source custom functions
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi

# Basic exports (fast)
export EZA_ICONS_AUTO=1
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.tmuxifier/bin:$PATH"
export PATH="/usr/local/opt/util-linux/bin:$PATH"
export PATH="/usr/local/opt/util-linux/sbin:$PATH"

# Existing aliases (fast)
alias ls="eza --icons=always --group-directories-first"
alias ll="eza --icons=always --group-directories-first -l"
alias la="eza --icons=always --group-directories-first -la"

# Conditional Rust tool aliases
if command -v bat &> /dev/null; then
    alias cat="bat --style=auto"
    alias ccat="bat --style=plain"  # plain cat when needed
fi

if command -v fd &> /dev/null; then
    alias find="fd"
fi

if command -v rg &> /dev/null; then
    alias grep="rg"
fi

if command -v dust &> /dev/null; then
    alias du="dust"
fi

if command -v delta &> /dev/null; then
    # Configure git to use delta
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.light false
fi

if command -v procs &> /dev/null; then
    alias ps="procs"
fi

if command -v sd &> /dev/null; then
    alias sed="sd"
fi

if command -v bandwhich &> /dev/null; then
    alias netmon="sudo bandwhich"
fi

if command -v diskonaut &> /dev/null; then
    alias diskusage="diskonaut"
fi

if command -v dua &> /dev/null; then
    alias dua="dua interactive"
fi

if command -v just &> /dev/null; then
    alias j="just"
fi

# Yazi file manager with directory changing capability
if command -v yazi &> /dev/null; then
    function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
    
    # Additional yazi aliases
    alias fm="y"           # File manager shortcut
    alias files="y"        # Alternative file manager alias
fi

# Tool initializations (now safe for VSCode)
eval "$(starship init bash)"

# Initialize zoxide with cd replacement
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init --cmd cd bash)"
    # Additional zoxide aliases
    alias z="cd"           # Explicit z command still available
    alias zi="cd -i"       # Interactive mode
    alias zz="cd -"        # Switch to previous directory
else
    # Fallback if zoxide isn't available
    alias cv="cd"
fi

eval "$(tmuxifier init -)"
eval "$(thefuck --alias)"

# export WOLFRAMSCRIPT_KERNELPATH="ssh daniel@100.84.89.49 /opt/Wolfram/WolframEngine/14.2/Executables/WolframKernel"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/danielramirez/.lmstudio/bin"
# End of LM Studio CLI section


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
