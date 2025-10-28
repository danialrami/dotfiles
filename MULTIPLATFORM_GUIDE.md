# Multi-Platform Dotfiles Architecture

This guide explains how the dotfiles repository now supports multiple platforms (macOS, Arch Linux, Ubuntu, etc.) with a single unified codebase.

## Overview

Previously, different machines used separate git branches:
- `klaxon` (macOS) - this computer
- `siku` (Arch Linux)

This created maintenance overhead and made it difficult to share common configurations. The new architecture uses **environment detection** to conditionally load platform-specific configs from a single `main` branch.

## Architecture

### Core Components

#### 1. Environment Detection (`scripts/detect-env.sh`, `scripts/detect_env.py`)

Automatically detects the current machine:

```bash
$ source ~/.dotfiles/scripts/detect-env.sh
$ echo $DOTFILES_OS        # "darwin" or "linux"
$ echo $DOTFILES_DISTRO    # "macos", "arch", "ubuntu", "fedora", etc.
$ echo $DOTFILES_HOSTNAME  # machine hostname (e.g., "klaxon", "siku")
```

**Supported platforms:**
- macOS (Darwin) → `DOTFILES_OS=darwin, DOTFILES_DISTRO=macos`
- Arch Linux → `DOTFILES_OS=linux, DOTFILES_DISTRO=arch`
- Ubuntu → `DOTFILES_OS=linux, DOTFILES_DISTRO=ubuntu`
- Fedora → `DOTFILES_OS=linux, DOTFILES_DISTRO=fedora`
- Debian → `DOTFILES_OS=linux, DOTFILES_DISTRO=debian`

#### 2. Modular Config Structure

Configurations are split into:
- **Common/Base** - Shared across all platforms
- **Platform variants** - OS/distro-specific overrides

### Configuration Files

#### Starship Prompt

```
starship/
├── starship.toml              # Current config (deployed)
├── starship.common.toml       # Shared modules
├── starship.darwin.toml       # macOS-specific theme/symbols
└── starship.arch.toml         # Arch Linux-specific (from siku)
```

**How it works:**
- `load-starship-config.sh` selects the right variant based on environment
- Set `STARSHIP_CONFIG` env var to point to platform config

#### Fish Shell

```
fish/.config/fish/
├── config.fish                # Main config (auto-sources conf.d)
└── conf.d/
    ├── 00-environment.fish    # Common env setup
    ├── 01-platform.fish       # macOS/Arch-specific setup
    └── 02-tools.fish          # Tool initializations
```

**How it works:**
- `config.fish` auto-sources all `conf.d/*.fish` files
- `01-platform.fish` conditionally loads macOS or Arch config
- Fish automatically sources `~/.config/fish/conf.d/` on startup

#### Neovim

```
neovim/.config/nvim/
├── lazy-lock.json             # Current lock file
├── lazy-lock.darwin.json      # macOS plugin versions
└── lazy-lock.arch.json        # Arch Linux plugin versions
```

**How it works:**
- `init-nvim-lockfile.sh` symlinks the correct lock file per platform
- Run this script after deploying dotfiles
- Each platform can have different plugin versions

### Backup/Restore Scripts

Both `backup-dotfiles.py` and `restore-dotfiles.py` are now platform-aware:

```python
from detect_env import EnvironmentDetector

detector = EnvironmentDetector()
os_type, distro, hostname = detector.detect()

# Filter packages based on OS
if os_type == "darwin":
    packages = ["bash", "zsh", "tmux", "wezterm", "brew", 
                "starship", "neovim", "opencode", "fish", "ghostty", "vscodium"]
elif os_type == "linux":
    packages = ["bash", "zsh", "tmux", 
                "starship", "neovim", "opencode", "fish", "nushell"]
```

## Supported Packages

### All Platforms
- `bash` - Bash configuration
- `zsh` - Zsh configuration
- `tmux` - Terminal multiplexer
- `starship` - Shell prompt
- `neovim` - Text editor
- `opencode` - OpenCode config

### macOS Only
- `wezterm` - Terminal emulator
- `brew` - Homebrew packages
- `fish` - Fish shell config
- `ghostty` - Ghostty terminal
- `vscodium` - VSCodium editor

### Linux Only
- `fish` - Fish shell config
- `nushell` - Nushell config

## Testing

### Run Environment Detection Tests

```bash
cd ~/.dotfiles
python3 -m unittest tests.test_detect_env -v
# 19 passing tests
```

### Run Integration Tests

```bash
cd ~/.dotfiles
python3 -m unittest tests.test_integration -v
# 15 passing tests
```

These tests verify:
- Platform detection works correctly
- All config files exist
- Modular structure is correct
- Lock files are in place
- Scripts are executable

## Usage

### On a New macOS Machine

```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
python3 restore-dotfiles.py
source ~/.dotfiles/scripts/init-nvim-lockfile.sh
```

### On a New Arch Linux Machine

```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
python3 restore-dotfiles.py
source ~/.dotfiles/scripts/init-nvim-lockfile.sh
```

The script automatically detects your OS and deploys the right configs!

### Updating Dotfiles

```bash
cd ~/.dotfiles
python3 backup-dotfiles.py
# Automatically detects platform and backs up only relevant configs
# Commits with platform info in message
```

### Editing Configs

Since configs are symlinked, edit in working location (`~/.config/`) or source location (`~/.dotfiles/`):

```bash
# Both work (same file due to symlink)
vim ~/.config/fish/config.fish
vim ~/.dotfiles/fish/.config/fish/config.fish
```

Changes are immediately reflected and can be committed to git.

## Platform-Specific Logic Examples

### Fish Shell (01-platform.fish)

```fish
if test "$DOTFILES_OS" = "darwin"
    # macOS-specific setup
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
else if test "$DOTFILES_DISTRO" = "arch"
    # Arch-specific setup
    source ~/.dotfiles/shared/go_env_arch.fish
end
```

### Shell Scripts (detect-env.sh)

```bash
source ~/.dotfiles/scripts/detect-env.sh

if [[ "$DOTFILES_DISTRO" == "macos" ]]; then
    # macOS logic
    STARSHIP_CONFIG="$HOME/.config/starship/starship.darwin.toml"
elif [[ "$DOTFILES_DISTRO" == "arch" ]]; then
    # Arch logic
    STARSHIP_CONFIG="$HOME/.config/starship/starship.arch.toml"
fi
```

## Adding New Machines

To add support for a new OS/distro:

1. **Update detect_env.py**
   - Add distro ID mapping if needed
   
2. **Create platform configs**
   - Add `starship.newos.toml` if needed
   - Add conditionals in `fish/conf.d/01-platform.fish`
   
3. **Update backup-dotfiles.py and restore-dotfiles.py**
   - Add distro to package filtering logic
   
4. **Test**
   - Run integration tests
   - Add tests for new platform

## Environment Variables

These are set by `detect-env.sh`:

| Variable | Example | Values |
|----------|---------|--------|
| `DOTFILES_OS` | `darwin` | `darwin`, `linux` |
| `DOTFILES_DISTRO` | `macos` | `macos`, `arch`, `ubuntu`, `fedora`, `debian`, etc. |
| `DOTFILES_HOSTNAME` | `klaxon` | Machine hostname |

Use these in any shell config to conditionally load platform-specific settings.

## Debug Mode

Enable debug output:

```bash
DOTFILES_DEBUG=1 source ~/.dotfiles/scripts/detect-env.sh
# Output: [dotfiles-env] OS: darwin, Distro: macos, Hostname: klaxon
```

## Migration from Branches

If migrating from branch-based approach:

1. Keep `main` as unified branch
2. Selectively pull platform-specific configs from feature branches
3. Use environment detection instead of manual switching
4. Delete old per-machine branches after verification

## File Structure Summary

```
~/.dotfiles/
├── scripts/
│   ├── detect-env.sh                  # Bash detection
│   ├── detect_env.py                  # Python detection
│   ├── load-starship-config.sh        # Select starship variant
│   ├── init-nvim-lockfile.sh          # Select nvim lock file
│   └── ...
│
├── starship/
│   ├── starship.toml                  # Deployed config
│   ├── starship.common.toml           # Shared modules
│   ├── starship.darwin.toml           # macOS
│   └── starship.arch.toml             # Arch (from siku)
│
├── fish/.config/fish/
│   ├── config.fish                    # Main config
│   └── conf.d/
│       ├── 00-environment.fish        # Common
│       ├── 01-platform.fish           # Platform-specific
│       └── 02-tools.fish              # Tools
│
├── neovim/.config/nvim/
│   ├── lazy-lock.json                 # Deployed lock
│   ├── lazy-lock.darwin.json          # macOS
│   └── lazy-lock.arch.json            # Arch
│
├── backup-dotfiles.py                 # Platform-aware backup
├── restore-dotfiles.py                # Platform-aware restore
├── tests/
│   ├── test_detect_env.py             # 19 unit tests
│   └── test_integration.py            # 15 integration tests
└── README.md
```

## Best Practices

1. **Keep common configs simple** - Put conditionals in platform variants
2. **Use environment variables** - Reference `DOTFILES_DISTRO` in configs
3. **Test before committing** - Run unit/integration tests
4. **Document new platforms** - Update this guide
5. **One symlink per config** - Don't hardcode machine-specific paths
6. **Version lock files per platform** - Each OS can have different plugin versions

## Troubleshooting

### Detection not working

```bash
# Test detection manually
bash ~/.dotfiles/scripts/detect-env.sh
python3 ~/.dotfiles/scripts/detect_env.py
```

### Symlinks broken

```bash
# Recreate symlinks
cd ~/.dotfiles
stow -D starship fish neovim
stow -t ~ starship fish neovim
```

### Config not loading

```bash
# Debug which config is being used
DOTFILES_DEBUG=1 fish
DOTFILES_DEBUG=1 bash
```

---

**Last Updated:** October 2025
**Status:** ✅ All tests passing (19 unit + 15 integration = 34 tests)
**Supported Platforms:** macOS (klaxon), Arch Linux (siku), extensible to others
