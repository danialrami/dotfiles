# OpenCode Configuration Package

This package contains the OpenCode configuration that integrates with the dotfiles repository using GNU stow.

## Structure

```
opencode/
└── .config/
    └── opencode/
        ├── opencode.json        (main config - symlinked)
        ├── .env.example         (environment template - symlinked)
        ├── package.json         (Node.js dependencies - symlinked)
        ├── bun.lock             (Bun lockfile - symlinked)
        ├── .gitignore           (local gitignore rules)
        ├── agent/               (AI agent configurations - symlinked)
        │   ├── coder.md
        │   └── vision.md
        └── instructions/        (development instructions - symlinked)
            └── DEVELOPMENT.md
```

## Installation

After stow creates the symlinks to `~/.config/opencode/`, install dependencies:

```bash
cd ~/.config/opencode
bun install
```

## Important Notes

- **node_modules/**: Not tracked in git (local only). Run `bun install` after deployment
- **.env**: Never commit actual .env files. Use .env.example as a template
- **.DS_Store**: Excluded from git (macOS artifact)
- **Symlinks**: Files like opencode.json, package.json, etc. are symlinked to the dotfiles repo

## Updating Configuration

When updating opencode config:
1. Modify files in `~/.dotfiles/opencode/.config/opencode/`
2. Changes are immediately reflected at `~/.config/opencode/` (via symlinks)
3. Commit changes to the dotfiles repository

## Restoring on a New Machine

```bash
cd ~/.dotfiles
stow -t ~ opencode
cd ~/.config/opencode
bun install
```

Or use the automated restore script:
```bash
python3 ~/.dotfiles/restore-dotfiles.py
```
