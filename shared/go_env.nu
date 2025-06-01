# ~/.dotfiles/shared/go_env.nu

# Go environment configuration
$env.GOROOT = (brew --prefix go | str trim) + "/libexec"
$env.GOPATH = $"($env.HOME)/go"
$env.PATH = ($env.PATH | prepend $"($env.GOPATH)/bin")
$env.PATH = ($env.PATH | prepend $"($env.GOROOT)/bin")
$env.PATH = ($env.PATH | prepend $"($env.HOME)/.local/bin")
