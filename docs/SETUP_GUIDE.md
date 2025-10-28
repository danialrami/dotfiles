# OpenCode Dotfiles Integration - Setup Guide

## Quick Reference

### Current Setup
Your opencode configuration has been successfully integrated into your dotfiles repository with GNU stow.

**Before:**
- `~/.config/opencode/` - Standalone configuration directory

**After:**
- `~/.dotfiles/opencode/.config/opencode/` - Source of truth (version controlled)
- `~/.config/opencode/` - Symlinked directory (all files point back to dotfiles)

## Visual Layout

```
Home Directory
│
├── .dotfiles/                         ← Git repository (version controlled)
│   ├── opencode/
│   │   ├── .config/
│   │   │   └── opencode/             ← SOURCE OF TRUTH
│   │   │       ├── opencode.json
│   │   │       ├── package.json
│   │   │       ├── .env.example
│   │   │       ├── bun.lock
│   │   │       ├── agent/
│   │   │       │   ├── coder.md
│   │   │       │   └── vision.md
│   │   │       └── instructions/
│   │   │           └── DEVELOPMENT.md
│   │   └── README.md
│   ├── bash/
│   ├── fish/
│   ├── neovim/
│   └── ... (other packages)
│
└── .config/
    └── opencode/                     ← SYMLINKED (all files point to .dotfiles)
        ├── opencode.json             → ../../.dotfiles/opencode/.config/opencode/opencode.json
        ├── package.json              → ../../.dotfiles/opencode/.config/opencode/package.json
        ├── .env.example              → ../../.dotfiles/opencode/.config/opencode/.env.example
        ├── agent/
        │   ├── coder.md              → ../../../.dotfiles/opencode/.config/opencode/agent/coder.md
        │   └── vision.md             → ../../../.dotfiles/opencode/.config/opencode/agent/vision.md
        ├── instructions/
        ├── node_modules/             ← Local only, ignored by git
        └── .gitignore
```

## Daily Workflow

### Editing Configuration
Since files are symlinked, you can edit them from either location:

```bash
# Edit at ~/.config/opencode/ (working location)
vim ~/.config/opencode/opencode.json

# Changes are automatically reflected at ~/.dotfiles/opencode/
# (because of the symlink)
```

### Adding New Files
1. Create the file in `~/.dotfiles/opencode/.config/opencode/`
2. Run stow to create the symlink:
   ```bash
   cd ~/.dotfiles
   stow -t ~ opencode
   ```
3. Verify it's available at `~/.config/opencode/`
4. Commit to git

### Installing Dependencies
```bash
cd ~/.config/opencode
bun install
```

## Automation Scripts

All Python scripts run in an isolated virtual environment (`.venv/`) for reproducible builds across machines.

### Backup & Sync (backup-dotfiles.sh)
Orchestrator script that manages venv and runs the Python backup script:
```bash
cd ~/.dotfiles
./backup-dotfiles.sh
```

This will:
1. Create/activate virtual environment
2. Update Homebrew's Brewfile (macOS only)
3. Backup existing files before symlinking
4. Create symlinks for all platform-appropriate packages
5. Commit changes locally
6. Print reminder to manually push to GitHub

### Restore on New Machine (restore-dotfiles.sh)
Orchestrator script for initial setup on a new machine:
```bash
cd ~/.dotfiles
./restore-dotfiles.sh
```

This will:
1. Create/activate virtual environment
2. Clone your dotfiles repo (if not already present)
3. Install Homebrew (macOS only)
4. Restore Homebrew packages from Brewfile (macOS only)
5. Create symlinks for all platform-appropriate packages
6. Then run: `cd ~/.config/opencode && bun install`

### Why Virtual Environment?
- **Reproducible**: Same Python environment on all machines
- **Isolated**: No conflicts with system Python or other tools
- **Minimal**: requirements.txt contains exactly what's needed

## Common Tasks

### Commit Updated Configuration
```bash
cd ~/.dotfiles
git add opencode/
git commit -m "Update opencode configuration"
git push
```

### Deploy to Another Machine
```bash
# Clone dotfiles
git clone <your-repo> ~/.dotfiles

# Run restoration (sets up venv automatically)
~/.dotfiles/restore-dotfiles.sh

# Install dependencies
cd ~/.config/opencode
bun install
```

### Check Symlink Status
```bash
# All symlinked files at ~/.config/opencode/
ls -la ~/.config/opencode/

# Verify a specific symlink
readlink ~/.config/opencode/opencode.json
```

### Troubleshoot Broken Symlinks
```bash
# Remove old symlinks
cd ~/.dotfiles
stow -D opencode

# Recreate them
stow -t ~ opencode --adopt
```

## Files Tracked in Git

### Included (tracked)
- ✓ `opencode.json` - Configuration
- ✓ `package.json` - Dependencies definition
- ✓ `bun.lock` - Lock file (for reproducible installs)
- ✓ `.env.example` - Template (never actual secrets)
- ✓ `agent/` - Agent configurations
- ✓ `instructions/` - Documentation

### Excluded (not tracked)
- ✗ `node_modules/` - Install locally with `bun install`
- ✗ `.env` - Never commit secrets (use .env.example)
- ✗ `.DS_Store` - macOS artifacts
- ✗ `package-lock.json` - Use bun.lock instead

## Key Advantages

1. **Version Control**: OpenCode config versioned with dotfiles
2. **Easy Sync**: Same workflow for all configuration
3. **Backup**: Automatic backups via dotfiles backup script
4. **Restore**: One-command restoration on new machines
5. **Consistency**: All packages use same stow-based setup
6. **Clean**: node_modules regenerated per machine

## Troubleshooting

### "Permission denied" when editing
Files are symlinked, not copies. Permissions should be fine.
```bash
ls -la ~/.config/opencode/opencode.json
# Should show: lrwxr-xr-x ... opencode.json -> ../../.dotfiles/opencode/...
```

### node_modules missing
Run from `~/.config/opencode/`:
```bash
cd ~/.config/opencode
bun install
```

### Symlinks broken after update
Re-run stow:
```bash
cd ~/.dotfiles
stow -D opencode
stow -t ~ opencode --adopt
```

### "Conflicts" during stow
This typically means files already exist. Use `--adopt`:
```bash
cd ~/.dotfiles
stow -t ~ opencode --adopt
```

## Related Documentation

- `~/.dotfiles/opencode/README.md` - Package-specific docs
- `~/.dotfiles/OPENCODE_INTEGRATION.md` - Technical integration details
- `~/.dotfiles/README.md` - Main dotfiles documentation

## Questions?

Reference the backup/restore scripts:
- `~/.dotfiles/backup-dotfiles.sh` - Orchestrator for backup (manages venv)
- `~/.dotfiles/restore-dotfiles.sh` - Orchestrator for restoration (manages venv)
- `~/.dotfiles/backup-dotfiles.py` - Actual backup logic (called by .sh)
- `~/.dotfiles/restore-dotfiles.py` - Actual restoration logic (called by .sh)
- `~/.dotfiles/requirements.txt` - Python dependencies (currently empty, stdlib only)
- `~/.dotfiles/.venv/` - Virtual environment (created automatically on first run)
