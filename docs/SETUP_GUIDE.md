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

### Backup & Sync (backup-dotfiles.py)
Updated to handle opencode automatically:
```python
"opencode": {"files": [".config/opencode"], "target": "~", "is_dir": True}
```

Run with:
```bash
cd ~/.dotfiles
python3 backup-dotfiles.py
```

### Restore on New Machine (restore-dotfiles.py)
Updated to include opencode in the stow packages list:
```bash
python3 ~/.dotfiles/restore-dotfiles.py
```

This will:
1. Clone your dotfiles repo
2. Install Homebrew packages
3. Create symlinks for all packages (including opencode)
4. You then run: `cd ~/.config/opencode && bun install`

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

# Run restoration
python3 ~/.dotfiles/restore-dotfiles.py

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

Reference the backup/restore scripts for exact stow commands:
- `~/.dotfiles/backup-dotfiles.py` - Manual backup workflow
- `~/.dotfiles/restore-dotfiles.py` - Automatic restoration setup
