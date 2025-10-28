# ~/.config/nushell/env.nu

# This file is loaded before config.nu
# Use it for environment variables that need to be available early

# Homebrew environment (if using Homebrew)
if ("/opt/homebrew/bin/brew" | path exists) {
    $env.PATH = ($env.PATH | prepend "/opt/homebrew/bin")
    $env.PATH = ($env.PATH | prepend "/opt/homebrew/sbin")
} else if ("/usr/local/bin/brew" | path exists) {
    $env.PATH = ($env.PATH | prepend "/usr/local/bin")
    $env.PATH = ($env.PATH | prepend "/usr/local/sbin")
}

# XDG Base Directory Specification
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
$env.XDG_DATA_HOME = $"($env.HOME)/.local/share"
$env.XDG_CACHE_HOME = $"($env.HOME)/.cache"

# Default applications
$env.BROWSER = "open"
$env.PAGER = "less"

# History configuration
$env.HISTFILE = $"($env.XDG_DATA_HOME)/nushell/history.txt"
