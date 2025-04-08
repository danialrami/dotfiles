#!/usr/bin/env python3

import os
import subprocess
from datetime import datetime

# Define paths and commands
DOTFILES_REPO = "https://github.com/danialrami/dotfiles"  # Replace with your repo URL
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
        print(result.stdout.strip())
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {command}\n{e}")
        return None

def clone_dotfiles():
    """Clone the dotfiles repository."""
    if not os.path.exists(DOTFILES_DIR):
        print("[INFO] Cloning dotfiles repository...")
        run_command(f"git clone {DOTFILES_REPO} {DOTFILES_DIR}")
    else:
        print("[INFO] Dotfiles repository already exists. Pulling latest changes...")
        run_command(f"cd {DOTFILES_DIR} && git pull")

def install_homebrew():
    """Install Homebrew if it's not already installed."""
    print("[INFO] Checking for Homebrew installation...")
    if run_command("which brew") is None:
        print("[INFO] Installing Homebrew...")
        run_command('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
    else:
        print("[INFO] Homebrew is already installed.")

def restore_brewfile():
    """Restore applications from the Brewfile."""
    print("[INFO] Restoring applications from Brewfile...")
    run_command(f"brew bundle --file={BREWFILE_PATH}")

def stow_packages():
    """Stow all defined packages."""
    print("[INFO] Stowing packages...")
    for package in STOW_PACKAGES:
        target_dir = CONFIG_TARGETS.get(package, "~")
        command = f"stow -t {os.path.expanduser(target_dir)} {package}"
        print(f"[INFO] Running: {command}")
        run_command(command)
    print("[INFO] Stowing complete.")

def main():
    """Main function to restore dotfiles and environment."""
    print("[INFO] Starting dotfiles restoration...")

    # Clone dotfiles repository
    clone_dotfiles()

    # Install Homebrew
    install_homebrew()

    # Restore Brewfile
    restore_brewfile()

    # Stow packages
    stow_packages()

    print("[INFO] Dotfiles restoration complete.")

if __name__ == "__main__":
    main()
