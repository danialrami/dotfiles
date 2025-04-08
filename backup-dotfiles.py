#!/usr/bin/env python3

import os
import subprocess
from datetime import datetime

# Define paths and commands
DOTFILES_DIR = os.path.expanduser("~/.dotfiles")
BREWFILE_PATH = os.path.join(DOTFILES_DIR, "brew/Brewfile")
STOW_PACKAGES = ["bash", "zsh", "tmux", "wezterm", "brew", "starship", "neovim"]
CONFIG_TARGETS = {
    "starship": "~/.config",
    "neovim": "~/.config",
}

def run_command(command):
    """Run a shell command and return its output."""
    try:
        result = subprocess.run(command, shell=True, check=True, text=True, capture_output=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {command}\n{e}")
        return None

def update_brewfile():
    """Update the Brewfile with current Homebrew packages."""
    print("[INFO] Updating Brewfile...")
    run_command(f"brew bundle dump --force --file={BREWFILE_PATH}")
    print("[INFO] Brewfile updated.")

def stow_packages():
    """Stow all defined packages."""
    print("[INFO] Stowing packages...")
    for package in STOW_PACKAGES:
        target_dir = CONFIG_TARGETS.get(package, "~")
        command = f"stow -t {os.path.expanduser(target_dir)} {package}"
        print(f"[INFO] Running: {command}")
        run_command(command)
    print("[INFO] Stowing complete.")

def commit_changes():
    """Commit changes to the dotfiles repository."""
    print("[INFO] Committing changes to Git...")
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    run_command(f"cd {DOTFILES_DIR} && git add . && git commit -m 'Update dotfiles: {timestamp}'")
    print("[INFO] Changes committed.")

def push_to_github():
    """Push changes to GitHub."""
    print("[INFO] Pushing changes to GitHub...")
    run_command(f"cd {DOTFILES_DIR} && git push")
    print("[INFO] Changes pushed.")

def main():
    """Main function to update dotfiles."""
    print("[INFO] Starting dotfiles update...")
    
    # Update Brewfile
    update_brewfile()

    # Stow packages
    stow_packages()

    # Commit and push changes
    commit_changes()
    push_to_github()

    print("[INFO] Dotfiles update complete.")

if __name__ == "__main__":
    main()
