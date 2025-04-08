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
    "neovim": {"files": [".config/nvim"], "target": "~", "is_dir": True}
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

def update_brewfile():
    """Update the Brewfile with current Homebrew packages."""
    print("[INFO] Updating Brewfile...")
    run_command(f"brew bundle dump --force --file={BREWFILE_PATH}", verbose=False)
    print("[INFO] Brewfile updated.")

def backup_existing_files():
    """Backup existing files that will be replaced by symlinks."""
    print("[INFO] Backing up existing files...")
    os.makedirs(BACKUP_DIR, exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_subdir = os.path.join(BACKUP_DIR, f"backup_{timestamp}")
    os.makedirs(backup_subdir, exist_ok=True)
    
    for package, config in PACKAGES.items():
        target_dir = os.path.expanduser(config["target"])
        for file in config["files"]:
            target_path = os.path.join(target_dir, file)
            backup_path = os.path.join(backup_subdir, package, file)
            
            if os.path.exists(target_path) and not os.path.islink(target_path):
                # Create parent directories for backup
                os.makedirs(os.path.dirname(backup_path), exist_ok=True)
                print(f"[INFO] Backing up {target_path} to {backup_path}")
                try:
                    shutil.copy2(target_path, backup_path) if os.path.isfile(target_path) else \
                    shutil.copytree(target_path, backup_path)
                except Exception as e:
                    print(f"[WARN] Failed to backup {target_path}: {e}")

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
            elif os.path.isdir(target_path) and config.get("is_dir", False) and os.path.exists(target_path):
                # Handle directory symlinks like nvim folder
                print(f"[INFO] Removing directory: {target_path}")
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
            
            # Check if source exists before creating symlink
            if not os.path.exists(source_path):
                print(f"[ERROR] Source path does not exist: {source_path}")
                continue
                
            print(f"[INFO] Creating symlink: {target_path} → {source_path}")
            try:
                os.symlink(source_path, target_path)
            except FileExistsError:
                print(f"[WARN] Target already exists: {target_path}")

def commit_changes():
    """Commit changes to the dotfiles repository."""
    print("[INFO] Committing changes to Git...")
    
    # Check if there are changes to commit
    status = run_command(f"cd {DOTFILES_DIR} && git status --porcelain", verbose=False)
    if not status:
        print("[INFO] No changes to commit.")
        return
        
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    run_command(f"cd {DOTFILES_DIR} && git add . && git commit -m 'Update dotfiles: {timestamp}'", verbose=False)
    print("[INFO] Changes committed.")

def push_to_github():
    """Push changes to GitHub."""
    print("[INFO] Pushing changes to GitHub...")
    run_command(f"cd {DOTFILES_DIR} && git push", verbose=False)
    print("[INFO] Changes pushed.")

def main():
    """Main function to update dotfiles."""
    print("[INFO] Starting dotfiles update...")
    
    # Update Brewfile
    update_brewfile()
    
    # Backup existing files
    backup_existing_files()
    
    # Remove existing symlinks
    remove_symlinks()
    
    # Create new symlinks
    create_symlinks()
    
    # Commit and push changes
    commit_changes()
    push_to_github()
    
    print("[INFO] Dotfiles update complete.")

if __name__ == "__main__":
    main()
