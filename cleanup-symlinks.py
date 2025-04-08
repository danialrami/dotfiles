#!/usr/bin/env python3

import os
import subprocess
import shutil
from datetime import datetime

# Define paths and commands
DOTFILES_DIR = os.path.expanduser("~/.dotfiles")
BREWFILE_PATH = os.path.join(DOTFILES_DIR, "brew/Brewfile")
BACKUP_DIR = os.path.expanduser("~/dotfiles-backup")

# Explicitly define each package's mapping (source → target)
PACKAGES = {
    "bash": {"files": [".bashrc"], "target": "~"},
    "zsh": {"files": [".zshrc"], "target": "~"},
    "tmux": {"files": [".tmux.conf"], "target": "~"},
    "wezterm": {"files": [".wezterm.lua"], "target": "~"},
    "brew": {"files": ["Brewfile"], "target": "~"},
    "starship": {"files": ["starship.toml"], "target": "~/.config"},
    "neovim": {"files": [".config/nvim"], "target": "~", "is_dir": True}  # Note: structure is different
}

def run_command(command, verbose=True):
    """Run a shell command and return its output."""
    try:
        result = subprocess.run(command, shell=True, check=True, text=True, capture_output=True)
        if verbose and result.stdout:
            print(result.stdout.strip())
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {command}\n{e}")
        return None

def remove_symlinks():
    """Remove existing symlinks for all packages."""
    print("[INFO] Removing existing symlinks...")
    
    for package, config in PACKAGES.items():
        target_dir = os.path.expanduser(config["target"])
        for file in config["files"]:
            target_path = os.path.join(target_dir, file)
            if os.path.islink(target_path):
                print(f"[INFO] Removing symlink: {target_path}")
                os.unlink(target_path)
            elif os.path.isdir(target_path) and config.get("is_dir", False):
                # Handle directory symlinks like nvim folder
                print(f"[INFO] Removing directory symlink: {target_path}")
                shutil.rmtree(target_path)

def create_symlinks():
    """Create symlinks for all packages."""
    print("[INFO] Creating symlinks...")
    
    for package, config in PACKAGES.items():
        source_dir = os.path.join(DOTFILES_DIR, package)
        target_dir = os.path.expanduser(config["target"])
        os.makedirs(target_dir, exist_ok=True)
        
        for file in config["files"]:
            source_path = os.path.join(source_dir, file)
            target_path = os.path.join(target_dir, file)
            
            # Ensure parent directory exists
            parent_dir = os.path.dirname(target_path)
            os.makedirs(parent_dir, exist_ok=True)
            
            print(f"[INFO] Creating symlink: {target_path} → {source_path}")
            os.symlink(source_path, target_path)

def main():
    """Main function to update dotfiles."""
    print("[INFO] Starting dotfiles update...")
    
    # Remove existing symlinks
    remove_symlinks()
    
    # Create new symlinks
    create_symlinks()
    
    print("[INFO] Dotfiles update complete.")

if __name__ == "__main__":
    main()
