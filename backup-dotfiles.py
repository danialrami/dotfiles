#!/usr/bin/env python3

import os
import subprocess
import shutil
import sys
from datetime import datetime
from pathlib import Path

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "scripts"))

from detect_env import EnvironmentDetector

DOTFILES_DIR = os.path.expanduser("~/.dotfiles")
BREWFILE_PATH = os.path.join(DOTFILES_DIR, "brew/Brewfile")
BACKUP_DIR = os.path.expanduser("~/dotfiles-backup")

PACKAGES = {
    "bash": {"files": [".bashrc"], "target": "~"},
    "zsh": {"files": [".zshrc"], "target": "~"},
    "tmux": {"files": [".tmux.conf"], "target": "~"},
    "wezterm": {"files": [".wezterm.lua"], "target": "~"},
    "brew": {"files": ["Brewfile"], "target": "~"},
    "starship": {"files": ["starship.toml"], "target": "~/.config"},
    "neovim": {"files": [".config/nvim"], "target": "~", "is_dir": True},
    "opencode": {"files": [".config/opencode"], "target": "~", "is_dir": True},
    "fish": {"files": [".config/fish"], "target": "~", "is_dir": True},
    "ghostty": {"files": ["Library/Application Support"], "target": "~", "is_dir": True},
    "vscodium": {"files": ["Library/Application Support"], "target": "~", "is_dir": True},
    "nushell": {"files": [".config/nushell"], "target": "~", "is_dir": True},
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

def get_platform_specific_packages(detector):
    """Return packages relevant to the current platform."""
    os_type = detector.detect_os()
    
    if os_type == "darwin":
        return ["bash", "zsh", "tmux", "wezterm", "brew", "starship", "neovim", "opencode", "fish", "ghostty", "vscodium"]
    elif os_type == "linux":
        return ["bash", "zsh", "tmux", "starship", "neovim", "opencode", "fish", "nushell"]
    else:
        return list(PACKAGES.keys())

def backup_existing_files(detector):
    """Backup existing files that will be replaced by symlinks."""
    print("[INFO] Backing up existing files...")
    os.makedirs(BACKUP_DIR, exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_subdir = os.path.join(BACKUP_DIR, f"backup_{timestamp}_{detector.detect_distro()}")
    os.makedirs(backup_subdir, exist_ok=True)
    
    packages_to_backup = get_platform_specific_packages(detector)
    
    for package in packages_to_backup:
        if package not in PACKAGES:
            continue
            
        config = PACKAGES[package]
        target_dir = os.path.expanduser(config["target"])
        for file in config["files"]:
            target_path = os.path.join(target_dir, file)
            backup_path = os.path.join(backup_subdir, package, file)
            
            if os.path.exists(target_path) and not os.path.islink(target_path):
                os.makedirs(os.path.dirname(backup_path), exist_ok=True)
                print(f"[INFO] Backing up {target_path} to {backup_path}")
                try:
                    if os.path.isfile(target_path):
                        shutil.copy2(target_path, backup_path)
                    else:
                        shutil.copytree(target_path, backup_path)
                except Exception as e:
                    print(f"[WARN] Failed to backup {target_path}: {e}")

def create_symlinks_with_stow(detector):
    """Create symlinks using GNU stow."""
    print("[INFO] Creating symlinks with stow...")
    
    packages_to_stow = get_platform_specific_packages(detector)
    
    for package in packages_to_stow:
        target_dir = PACKAGES.get(package, {}).get("target", "~")
        target_dir_expanded = os.path.expanduser(target_dir)
        command = f"cd {DOTFILES_DIR} && stow -t {target_dir_expanded} {package} --adopt"
        print(f"[INFO] Running: stow -t {target_dir_expanded} {package}")
        try:
            run_command(command, verbose=False)
        except Exception as e:
            print(f"[WARN] Stow failed for {package}: {e}")

def commit_changes(detector):
    """Commit changes to the dotfiles repository."""
    print("[INFO] Committing changes to Git...")
    
    status = run_command(f"cd {DOTFILES_DIR} && git status --porcelain", verbose=False)
    if not status:
        print("[INFO] No changes to commit.")
        return
        
    os_type = detector.detect_os()
    distro = detector.detect_distro()
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    message = f"Update dotfiles ({distro}): {timestamp}"
    
    run_command(f"cd {DOTFILES_DIR} && git add . && git commit -m '{message}'", verbose=False)
    print("[INFO] Changes committed.")

def push_to_github():
    """Push changes to GitHub."""
    print("[INFO] Pushing changes to GitHub...")
    run_command(f"cd {DOTFILES_DIR} && git push", verbose=False)
    print("[INFO] Changes pushed.")

def main():
    """Main function to update dotfiles."""
    detector = EnvironmentDetector()
    os_type, distro, hostname = detector.detect()
    
    print(f"[INFO] Starting dotfiles update for {distro} on {hostname}...")
    
    if os_type == "darwin":
        update_brewfile()
    
    backup_existing_files(detector)
    create_symlinks_with_stow(detector)
    commit_changes(detector)
    push_to_github()
    
    print("[INFO] Dotfiles update complete.")

if __name__ == "__main__":
    main()
