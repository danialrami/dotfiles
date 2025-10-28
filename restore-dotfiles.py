#!/usr/bin/env python3

import os
import sys
import subprocess

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "scripts"))

from detect_env import EnvironmentDetector

DOTFILES_REPO = "https://github.com/danialrami/dotfiles"
DOTFILES_DIR = os.path.expanduser("~/.dotfiles")
BREWFILE_PATH = os.path.join(DOTFILES_DIR, "brew/Brewfile")

STOW_PACKAGES = {
    "bash": "~",
    "zsh": "~",
    "tmux": "~",
    "wezterm": "~",
    "brew": "~",
    "starship": "~/.config",
    "neovim": "~/.config",
    "opencode": "~/.config",
    "fish": "~/.config",
    "ghostty": "~",
    "vscodium": "~",
    "nushell": "~/.config",
}

def run_command(command):
    """Run a shell command and return its output."""
    try:
        result = subprocess.run(command, shell=True, check=True, text=True, capture_output=True)
        if result.stdout:
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
    result = run_command("which brew")
    if result is None or result == "":
        print("[INFO] Installing Homebrew...")
        run_command(
            '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        )
    else:
        print("[INFO] Homebrew is already installed.")

def restore_brewfile(detector):
    """Restore applications from the Brewfile if on macOS."""
    os_type = detector.detect_os()
    
    if os_type != "darwin":
        print("[INFO] Skipping Brewfile restore (not on macOS)")
        return
    
    print("[INFO] Restoring applications from Brewfile...")
    run_command(f"brew bundle --file={BREWFILE_PATH}")

def get_platform_packages(detector):
    """Return packages relevant to the current platform."""
    os_type = detector.detect_os()
    
    if os_type == "darwin":
        return ["bash", "zsh", "tmux", "wezterm", "brew", "starship", "neovim", "opencode", "fish", "ghostty", "vscodium"]
    elif os_type == "linux":
        return ["bash", "zsh", "tmux", "starship", "neovim", "opencode", "fish", "nushell"]
    else:
        return list(STOW_PACKAGES.keys())

def stow_packages(detector):
    """Stow all defined packages for the current platform."""
    print("[INFO] Stowing packages...")
    
    packages_to_stow = get_platform_packages(detector)
    
    for package in packages_to_stow:
        if package not in STOW_PACKAGES:
            continue
            
        target_dir = STOW_PACKAGES[package]
        target_dir_expanded = os.path.expanduser(target_dir)
        command = f"cd {DOTFILES_DIR} && stow -t {target_dir_expanded} {package}"
        print(f"[INFO] Running: stow -t {target_dir_expanded} {package}")
        result = run_command(command)
        if result is None:
            print(f"[WARN] Stow may have failed for {package}")
    
    print("[INFO] Stowing complete.")

def main():
    """Main function to restore dotfiles and environment."""
    detector = EnvironmentDetector()
    os_type, distro, hostname = detector.detect()
    
    print(f"[INFO] Starting dotfiles restoration for {distro} on {hostname}...")

    clone_dotfiles()
    install_homebrew()
    restore_brewfile(detector)
    stow_packages(detector)

    print("[INFO] Dotfiles restoration complete.")
    print(f"[INFO] Environment: OS={os_type}, Distro={distro}, Hostname={hostname}")

if __name__ == "__main__":
    main()
