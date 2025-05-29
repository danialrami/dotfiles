# ~/.config/fish/functions/check_rust_tools.fish
function check_rust_tools --description "Check for installed Rust CLI tools"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: check_rust_tools"
        echo " Check for installed Rust CLI tools"
        echo ""
        echo "Checks for the following tools:"
        echo " bat, fd, rg, dust, delta, procs, btm, broot, sd, hyperfine,"
        echo " tokei, just, cargo-audit, cargo-wipe, difftastic, dog,"
        echo " bandwhich, diskonaut, dua, choose, eza, zoxide, starship, yazi"
        return 0
    end

    set tools bat fd rg dust delta procs btm broot sd hyperfine tokei just cargo-audit cargo-wipe difftastic dog bandwhich diskonaut dua choose eza zoxide starship yazi

    echo "Checking for Rust CLI tools..."
    set found 0
    set total (count $tools)

    for tool in $tools
        if command -v "$tool" > /dev/null
            echo "✓ $tool is installed ("(which $tool)")"
            set found (math $found + 1)
        else
            echo "✗ $tool not found"
        end
    end

    echo ""
    echo "Found $found/$total tools installed"
end
