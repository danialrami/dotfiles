# Dotfiles

![License](https://img.shields.io/badge/license-GPL--3.0-blue)

Unified dotfiles for cross-platform development environments on macOS (klaxon) and Arch Linux (siku).

## 🎯 Features

- **Multi-Platform Support** - Automatic platform detection (macOS, Arch Linux, extensible)
- **Modern Terminal** - tmux, Fish/Bash/Zsh, Starship prompt
- **Neovim IDE** - LSP support, Ollama/Claude AI integration, SuperCollider for audio
- **Audio Development** - SuperCollider integration, JACK support
- **AI-Assisted Coding** - Local models (Ollama) + Claude API
- **Cross-Platform Deployment** - Single `main` branch, environment-aware setup

## ⚡ Quick Start

### macOS
```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
python3 restore-dotfiles.py
```

### Arch Linux
```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
python3 restore-dotfiles.py
```

Platform-specific configs load automatically!

## 📚 Documentation

See [docs/](./docs/) for complete documentation:

- **[docs/MULTIPLATFORM_GUIDE.md](./docs/MULTIPLATFORM_GUIDE.md)** - Architecture and design
- **[docs/SETUP_GUIDE.md](./docs/SETUP_GUIDE.md)** - Usage and workflow
- **[docs/GIT_STRATEGY.md](./docs/GIT_STRATEGY.md)** - Branch strategy
- **[docs/INDEX.md](./docs/INDEX.md)** - Documentation index

## 🔧 What's Included

### Configurations
- **Fish Shell** - Modular conf.d structure with platform-specific setup
- **Starship Prompt** - Multi-theme support (darwin, arch, common)
- **Neovim** - LSP, plugins, per-platform lock files
- **Tmux** - Vim-like navigation, session management
- **Shell Utils** - Bash, Zsh with shared functions

### Tools & Integrations
- **Development** - Git, Docker, build tools
- **AI Coding** - Ollama, Claude, code assistance
- **Audio** - SuperCollider, JACK, music tools
- **Productivity** - Zoxide, Eza, Ripgrep, Yazi

### Packages
- **macOS**: 11 packages (includes Homebrew)
- **Arch Linux**: 8 packages (native tools)
- **Extensible** to Ubuntu, Fedora, Debian

## ✅ Testing

All components tested and verified:
```bash
cd ~/.dotfiles
python3 -m unittest tests.test_detect_env tests.test_integration -v
# 34 passing tests ✅
```

## 🏗️ Architecture

Environment detection automatically selects:
- Platform-specific configs (starship, fish setup)
- Per-OS package lists
- Appropriate deployment scripts
- Correct plugin versions (neovim)

No manual configuration needed!

## 📦 Installation Requirements

- Git 2.20+
- Python 3.8+
- GNU Stow
- Nerd Font (for terminal)
- macOS 10.15+ or Linux (Arch/Ubuntu/Fedora)

## 📋 Contents

```
~/.dotfiles/
├── README.md                 ← This file
├── docs/                     ← Full documentation
├── scripts/                  ← Platform detection & helpers
├── tests/                    ← 34 comprehensive tests
├── starship/                 ← Terminal prompt configs
├── fish/                     ← Fish shell configs
├── neovim/                   ← Editor configuration
├── tmux/                     ← Terminal multiplexer
├── bash/zsh/                 ← Legacy shells
├── brew/                     ← Homebrew packages (macOS)
├── opencode/                 ← OpenCode CLI config
└── ... (other configs)
```

## 🚀 Deployment

### First Time
```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
python3 restore-dotfiles.py
source ~/.dotfiles/scripts/init-nvim-lockfile.sh  # neovim setup
```

### Updates
```bash
cd ~/.dotfiles
git pull origin main
python3 backup-dotfiles.py  # auto-detects platform
```

## 🤝 Supported Machines

- **klaxon** (macOS) ✅
- **siku** (Arch Linux) ✅
- **ubuntu/fedora/debian** (✅ extensible)

## 📖 Learning More

- For architecture details: [docs/MULTIPLATFORM_GUIDE.md](./docs/MULTIPLATFORM_GUIDE.md)
- For workflow & troubleshooting: [docs/SETUP_GUIDE.md](./docs/SETUP_GUIDE.md)
- For implementation: [docs/IMPLEMENTATION_SUMMARY.md](./docs/IMPLEMENTATION_SUMMARY.md)
- For all docs: [docs/INDEX.md](./docs/INDEX.md)

## 📊 Status

✅ **Production Ready**
- 34 passing tests
- 1,340+ lines of documentation
- Multi-platform verified
- Clean atomic commit history

## 📄 License

GNU General Public License v3.0 - See [LICENSE](LICENSE) for details

---

**Last Updated**: October 2025  
**Platforms**: macOS, Arch Linux (extensible)  
**Tests**: 34 passing ✅
