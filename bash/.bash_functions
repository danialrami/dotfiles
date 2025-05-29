#!/bin/bash
# ~/.bash_functions

yt() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: yt <video_link>"
        echo "  Extract transcript from YouTube video using fabric"
        echo ""
        echo "Arguments:"
        echo "  video_link    YouTube video URL"
        echo ""
        echo "Example:"
        echo "  yt https://www.youtube.com/watch?v=..."
        return 0
    fi

    if ! command -v fabric &> /dev/null; then
        echo "Error: This function requires fabric"
        return 1
    fi
    
    local video_link="$1"
    fabric -y "$video_link" --transcript
}

# Function to check for Rust CLI tools
check_rust_tools() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: check_rust_tools"
        echo "  Check for installed Rust CLI tools"
        echo ""
        echo "Checks for the following tools:"
        echo "  bat, fd, rg, dust, delta, procs, btm, broot, sd, hyperfine,"
        echo "  tokei, just, cargo-audit, cargo-wipe, difftastic, dog,"
        echo "  bandwhich, diskonaut, dua, choose, eza, zoxide, starship, yazi"
        return 0
    fi

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

# Advanced file operations with modern tools
fzf_file() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: fzf_file"
        echo "  Find and edit files using fzf with bat preview"
        echo ""
        echo "Features:"
        echo "  - Searches for files recursively (excluding .git)"
        echo "  - Shows file preview using bat"
        echo "  - Opens selected file in \$EDITOR (default: nano)"
        return 0
    fi

    if ! command -v fd &> /dev/null || ! command -v fzf &> /dev/null || ! command -v bat &> /dev/null; then
        echo "Error: This function requires fd, fzf, and bat"
        return 1
    fi

    local file
    file=$(fd --type f --hidden --follow --exclude .git | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')
    if [[ -n $file ]]; then
        ${EDITOR:-nano} "$file"
    fi
}

# Smart directory navigation with preview
fzf_dir() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: fzf_dir"
        echo "  Navigate to directories using fzf with tree preview"
        echo ""
        echo "Features:"
        echo "  - Searches for directories recursively (excluding .git)"
        echo "  - Shows directory tree preview using eza"
        echo "  - Changes to selected directory"
        return 0
    fi

    if ! command -v fd &> /dev/null || ! command -v fzf &> /dev/null || ! command -v eza &> /dev/null; then
        echo "Error: This function requires fd, fzf, and eza"
        return 1
    fi

    local dir
    dir=$(fd --type d --hidden --follow --exclude .git | fzf --preview 'eza --tree --level=2 --icons {}')
    if [[ -n $dir ]]; then
        cd "$dir"
    fi
}

# Git workflow functions using delta
git_diff_fancy() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: git_diff_fancy [git diff arguments]"
        echo "  Show git diff output using delta for enhanced formatting"
        echo ""
        echo "Arguments:"
        echo "  All arguments are passed directly to 'git diff'"
        echo ""
        echo "Examples:"
        echo "  git_diff_fancy                # Show unstaged changes"
        echo "  git_diff_fancy --staged       # Show staged changes"
        echo "  git_diff_fancy HEAD~1         # Compare with previous commit"
        return 0
    fi

    if ! command -v git &> /dev/null || ! command -v delta &> /dev/null; then
        echo "Error: This function requires git and delta"
        return 1
    fi

    if [[ $# -eq 0 ]]; then
        git diff | delta
    else
        git diff "$@" | delta
    fi
}

git_log_fancy() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: git_log_fancy"
        echo "  Interactive git log browser with commit preview"
        echo ""
        echo "Features:"
        echo "  - Shows git log in graph format"
        echo "  - Interactive selection with fzf"
        echo "  - Preview commit details using delta"
        return 0
    fi

    if ! command -v git &> /dev/null || ! command -v fzf &> /dev/null || ! command -v delta &> /dev/null; then
        echo "Error: This function requires git, fzf, and delta"
        return 1
    fi

    git log --oneline --graph --color=always | fzf --ansi --preview 'git show --color=always {1} | delta'
}

# Process management with procs
kill_process() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: kill_process"
        echo "  Interactively select and kill a process"
        echo ""
        echo "Features:"
        echo "  - Lists processes using procs"
        echo "  - Interactive selection with fzf"
        echo "  - Kills selected process"
        return 0
    fi

    if ! command -v procs &> /dev/null || ! command -v fzf &> /dev/null; then
        echo "Error: This function requires procs and fzf"
        return 1
    fi

    local pid
    pid=$(procs | fzf --header-lines=1 | awk '{print $1}')
    if [[ -n $pid ]]; then
        echo "Killing process $pid..."
        kill "$pid"
    fi
}

# File search and replace workflow
search_replace() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: search_replace <search_pattern> <replacement> [file_pattern]"
        echo "  Search and replace text across multiple files"
        echo ""
        echo "Arguments:"
        echo "  search_pattern    Pattern to search for"
        echo "  replacement       Text to replace with"
        echo "  file_pattern      File pattern to match (default: *)"
        echo ""
        echo "Example:"
        echo "  search_replace 'old_text' 'new_text' '*.txt'"
        return 0
    fi

    if ! command -v rg &> /dev/null || ! command -v sd &> /dev/null; then
        echo "Error: This function requires rg (ripgrep) and sd"
        return 1
    fi

    if [[ $# -lt 2 ]]; then
        echo "Usage: search_replace <search_pattern> <replacement> [file_pattern]"
        return 1
    fi
    
    local search="$1"
    local replace="$2"
    local pattern="${3:-*}"
    
    echo "Searching for '$search' in $pattern files..."
    rg "$search" --files-with-matches "$pattern" | while read -r file; do
        echo "Processing: $file"
        sd "$search" "$replace" "$file"
    done
}

# Disk usage analysis
disk_analysis() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: disk_analysis [path]"
        echo "  Analyze disk usage for a directory"
        echo ""
        echo "Arguments:"
        echo "  path    Directory to analyze (default: current directory)"
        echo ""
        echo "Features:"
        echo "  - Shows overview using dust"
        echo "  - Opens interactive mode with diskonaut"
        echo ""
        echo "Example:"
        echo "  disk_analysis ~/Downloads"
        return 0
    fi

    if ! command -v dust &> /dev/null || ! command -v diskonaut &> /dev/null; then
        echo "Error: This function requires dust and diskonaut"
        return 1
    fi

    local path="${1:-.}"
    echo "Analyzing disk usage for: $path"
    echo "=== Overview ==="
    dust "$path"
    echo ""
    echo "=== Interactive mode ==="
    echo "Press 'q' to quit diskonaut"
    diskonaut "$path"
}

# Project statistics
project_stats() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: project_stats [path]"
        echo "  Display project statistics and code metrics"
        echo ""
        echo "Arguments:"
        echo "  path    Project directory (default: current directory)"
        echo ""
        echo "Shows:"
        echo "  - Code statistics using tokei"
        echo "  - File count by extension"
        echo "  - Largest files in the project"
        echo ""
        echo "Example:"
        echo "  project_stats ~/my_project"
        return 0
    fi

    if ! command -v tokei &> /dev/null || ! command -v fd &> /dev/null || ! command -v rg &> /dev/null; then
        echo "Error: This function requires tokei, fd, and rg (ripgrep)"
        return 1
    fi

    local path="${1:-.}"
    echo "=== Code Statistics ==="
    tokei "$path"
    echo ""
    echo "=== File Count by Type ==="
    fd --type f . "$path" | rg '\.' | rg -o '\.[^.]*$' | sort | uniq -c | sort -nr
    echo ""
    echo "=== Largest Files ==="
    fd --type f . "$path" -x ls -la {} | sort -k5 -nr | head -10
}

# Network monitoring shortcut
network_monitor() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: network_monitor"
        echo "  Monitor network traffic using bandwhich"
        echo ""
        echo "Features:"
        echo "  - Real-time network traffic monitoring"
        echo "  - Shows bandwidth usage by process"
        echo "  - Requires sudo privileges"
        echo ""
        echo "Controls:"
        echo "  Ctrl+C to stop monitoring"
        return 0
    fi

    if ! command -v bandwhich &> /dev/null; then
        echo "Error: This function requires bandwhich"
        return 1
    fi

    echo "Starting network monitoring (Ctrl+C to stop)..."
    sudo bandwhich
}

# Benchmark commands easily
bench() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: bench <command>"
        echo "  Benchmark command execution time using hyperfine"
        echo ""
        echo "Arguments:"
        echo "  command    Command to benchmark"
        echo ""
        echo "Examples:"
        echo "  bench 'ls -la'"
        echo "  bench 'find . -name \"*.txt\"'"
        echo "  bench 'grep -r pattern .'"
        return 0
    fi

    if ! command -v hyperfine &> /dev/null; then
        echo "Error: This function requires hyperfine"
        return 1
    fi

    if [[ $# -eq 0 ]]; then
        echo "Usage: bench <command>"
        return 1
    fi
    hyperfine "$@"
}

# Clean project directories
clean_projects() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: clean_projects [base_dir]"
        echo "  Find and clean Rust project build artifacts"
        echo ""
        echo "Arguments:"
        echo "  base_dir    Base directory to search (default: ~/Projects)"
        echo ""
        echo "Features:"
        echo "  - Finds Rust projects by Cargo.toml"
        echo "  - Shows target directory size"
        echo "  - Interactive cleanup prompt"
        echo ""
        echo "Example:"
        echo "  clean_projects ~/rust_projects"
        return 0
    fi

    if ! command -v fd &> /dev/null || ! command -v dust &> /dev/null || ! command -v cargo &> /dev/null; then
        echo "Error: This function requires fd, dust, and cargo"
        return 1
    fi

    local base_dir="${1:-$HOME/Projects}"
    echo "Finding Rust projects to clean in $base_dir..."
    
    fd "Cargo.toml" "$base_dir" -x dirname {} | while read -r project; do
        echo "Found Rust project: $project"
        if [[ -d "$project/target" ]]; then
            echo "  Has target directory ($(dust -s "$project/target" | head -1))"
            read -p "  Clean? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                (cd "$project" && cargo clean)
            fi
        fi
    done
}

# Quick file backup with timestamp
backup_file() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: backup_file <file>"
        echo "  Create a timestamped backup of a file"
        echo ""
        echo "Arguments:"
        echo "  file    File to backup"
        echo ""
        echo "Backup format:"
        echo "  <filename>.backup.YYYYMMDD_HHMMSS"
        echo ""
        echo "Example:"
        echo "  backup_file important.conf"
        echo "  # Creates: important.conf.backup.20231025_143052"
        return 0
    fi

    if [[ $# -eq 0 ]]; then
        echo "Usage: backup_file <file>"
        return 1
    fi
    
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "File not found: $file"
        return 1
    fi
    
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup"
    echo "Backed up to: $backup"
}

# Git repository health check
repo_health() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: repo_health [repo_path]"
        echo "  Check git repository health and status"
        echo ""
        echo "Arguments:"
        echo "  repo_path    Repository path (default: current directory)"
        echo ""
        echo "Shows:"
        echo "  - Recent commit activity"
        echo "  - Uncommitted changes"
        echo "  - Branch information"
        echo "  - Large files in repository"
        echo ""
        echo "Example:"
        echo "  repo_health ~/my_project"
        return 0
    fi

    if ! command -v git &> /dev/null || ! command -v fd &> /dev/null; then
        echo "Error: This function requires git and fd"
        return 1
    fi

    local repo_path="${1:-.}"
    cd "$repo_path" || return 1
    
    echo "=== Repository Health Check ==="
    echo "Repository: $(pwd)"
    echo ""
    
    echo "=== Recent Activity ==="
    git log --oneline -10
    echo ""
    
    echo "=== Uncommitted Changes ==="
    git status --porcelain
    echo ""
    
    echo "=== Branch Information ==="
    git branch -v
    echo ""
    
    echo "=== Large Files (>1MB) ==="
    fd --type f --size +1m . | xargs ls -lh | sort -k5 -hr
}

# Quick note taking with bat preview
note() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: note [note_name]"
        echo "  Create or browse markdown notes"
        echo ""
        echo "Arguments:"
        echo "  note_name    Name of note to create/edit (without .md extension)"
        echo ""
        echo "Features:"
        echo "  - No arguments: browse existing notes with preview"
        echo "  - With argument: create/edit note"
        echo "  - Notes stored in ~/Notes directory"
        echo ""
        echo "Examples:"
        echo "  note                  # Browse notes"
        echo "  note meeting-notes    # Create/edit meeting-notes.md"
        return 0
    fi

    local note_dir="$HOME/Notes"
    mkdir -p "$note_dir"
    
    if [[ $# -eq 0 ]]; then
        if ! command -v fd &> /dev/null || ! command -v fzf &> /dev/null || ! command -v bat &> /dev/null; then
            echo "Error: Browsing notes requires fd, fzf, and bat"
            return 1
        fi
        # List and preview notes
        fd --type f . "$note_dir" | fzf --preview 'bat --style=numbers --color=always {}'
    else
        # Create/edit note
        local note_file="$note_dir/$1.md"
        ${EDITOR:-nano} "$note_file"
    fi
}
