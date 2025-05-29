# ~/.bash_functions
yt() {
    local video_link="$1"
    fabric -y "$video_link" --transcript
}

# Function to check for Rust CLI tools
check_rust_tools() {
    local tools=("bat" "fd" "rg" "dust" "delta" "procs" "btm" "broot" "sd" "hyperfine" "tokei" "just" "cargo-audit" "cargo-wipe" "difftastic" "dog" "bandwhich" "diskonaut" "dua" "choose" "eza" "zoxide" "starship" "yazi")
    echo "Checking for Rust CLI tools..."
    local found=0
    local total=${#tools[@]}
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            echo "✓ $tool is installed ($(which $tool))"
            ((found++))
        else
            echo "✗ $tool not found"
        fi
    done
    
    echo ""
    echo "Found $found/$total tools installed"
}
