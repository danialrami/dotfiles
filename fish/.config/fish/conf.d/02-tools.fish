#!/usr/bin/env fish

if command -v starship > /dev/null
    starship init fish | source
end

if command -v zoxide > /dev/null
    zoxide init --cmd cd fish | source
end

if command -v tmuxifier > /dev/null
    tmuxifier init - fish | source
end

if command -v thefuck > /dev/null
    thefuck --alias | source
end

if command -v kubectl > /dev/null
    kubectl completion fish | source
end

if test -d /Users/danielramirez/.lmstudio/bin
    set -gx PATH $PATH /Users/danielramirez/.lmstudio/bin
end
