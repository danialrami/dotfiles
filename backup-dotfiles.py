#!/usr/bin/env python3

import os
import subprocess
import shutil
from datetime import datetime

# Define paths and commands
DOTFILES_DIR = os.path.expanduser("~/.dotfiles")
BREWFILE_PATH = os.path.join(DOTFILES_DIR, "brew/Brewfile")
BACKUP_DIR = os.path.expanduser("~/dotfiles-backup")
STOW_PACKAGES = ["bash", "zsh", "tmux", "wezterm", "brew", "starship", "neovim"]
CONFIG_TARGETS = {
    "starship": "~/.config",
    "neovim": "~/.config",
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

def backup_and_stow_packages():
    """Backup existing files and stow packages."""
    print("[INFO] Starting stow process with backup protection...")
    
    # Create backup directory if it doesn't exist
    os.makedirs(BACKUP_DIR, exist_ok=True)
    print(f"[INFO] Using backup directory: {BACKUP_DIR}")
    
    # Process each package
    for package in STOW_PACKAGES:
        print(f"[INFO] Processing package: {package}")
        
        # Determine target directory
        target_dir = os.path.expanduser(CONFIG_TARGETS.get(package, "~"))
        
        # Ensure target directory exists
        os.makedirs(target_dir, exist_ok=True)
        
        # Check and backup conflicting files
        package_dir = os.path.join(DOTFILES_DIR, package)
        if os.path.exists(package_dir):
            for root, dirs, files in os.walk(package_dir):
                # Get relative path from package directory
                rel_path = os.path.relpath(root, package_dir)
                if rel_path == ".":
                    rel_path = ""
                
                # Process each file
                for file in files:
                    # Get source and target paths
                    source_path = os.path.join(root, file)
                    target_rel_path = os.path.join(rel_path, file)
                    target_path = os.path.join(target_dir, target_rel_path)
                    
                    # If target exists and is not a symlink, back it up
                    if os.path.exists(target_path) and not os.path.islink(target_path):
                        backup_path = os.path.join(BACKUP_DIR, package, target_rel_path)
                        os.makedirs(os.path.dirname(backup_path), exist_ok=True)
                        print(f"[INFO] Backing up {target_path} to {backup_path}")
                        shutil.move(target_path, backup_path)
        
        # Now stow the package
        print(f"[INFO] Stowing package: {package} to {target_dir}")
        run_command(f"stow -t {target_dir} {package}", verbose=False)
    
    print("[INFO] Stowing complete.")

def commit_changes():
    """Commit changes to the dotfiles repository."""
    print("[INFO] Committing changes to Git...")
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

    # Backup and stow packages
    backup_and_stow_packages()

    # Commit and push changes
    commit_changes()
    push_to_github()

    print("[INFO] Dotfiles update complete.")

if __name__ == "__main__":
    main()
