# ~/.config/nushell/config.nu

# Default editor
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

# Environment variables
$env.EZA_ICONS_AUTO = "1"
$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"

# Path modifications (nushell uses lists for PATH)
$env.PATH = ($env.PATH | prepend $"($env.HOME)/.tmuxifier/bin")
$env.PATH = ($env.PATH | prepend "/usr/local/opt/util-linux/bin")
$env.PATH = ($env.PATH | prepend "/usr/local/opt/util-linux/sbin")

# Source shared configurations
source ~/.dotfiles/shared/go_env.nu
# source ~/.dotfiles/shared/secure_env.nu

# Starship prompt (fixed version)
if (which starship | is-not-empty) {
    $env.STARSHIP_SHELL = "nu"
    def create_left_prompt [] {
        let cmd_duration = if "CMD_DURATION_MS" in $env { $env.CMD_DURATION_MS } else { "0" }
        let last_exit_code = if "LAST_EXIT_CODE" in $env { $env.LAST_EXIT_CODE } else { "0" }
        starship prompt --cmd-duration $cmd_duration $"--status=($last_exit_code)"
    }
    def create_right_prompt [] {
        let cmd_duration = if "CMD_DURATION_MS" in $env { $env.CMD_DURATION_MS } else { "0" }
        let last_exit_code = if "LAST_EXIT_CODE" in $env { $env.LAST_EXIT_CODE } else { "0" }
        starship prompt --right --cmd-duration $cmd_duration $"--status=($last_exit_code)"
    }
    $env.PROMPT_COMMAND = {|| create_left_prompt }
    $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
}

# Zoxide integration
if (which zoxide | is-not-empty) {
    zoxide init nushell | save -f ~/.zoxide.nu
    source ~/.zoxide.nu
}

# Custom aliases (only where they don't conflict with nushell)
alias ccat = bat --style=plain
alias find = fd
alias grep = rg
alias netmon = sudo bandwhich
alias diskusage = diskonaut
alias j = just

# Audio development shortcuts
alias sc = supercollider
alias sclang = /Applications/SuperCollider.app/Contents/MacOS/sclang

# File manager aliases
alias fm = yazi
alias files = yazi

# Custom commands that replace problematic aliases
def ll [] {
    ls -l
}

def la [] {
    ls -la
}

def du-interactive [] {
    dua interactive
}

# Yazi with directory changing (nushell version)
def y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp | str trim)
    if ($cwd != "" and $cwd != $env.PWD) {
        cd $cwd
    }
    rm $tmp
}

# Git delta configuration (run once)
def setup-delta [] {
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.light false
}
