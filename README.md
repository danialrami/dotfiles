# Dotfiles

![License](https://img.shields.io/badge/license-GPL--3.0-blue)

## Overview

This repository contains configurations for an optimized development environment centered around:

- Modern terminal experience with **tmux**, **Wezterm**, and **Starship**
- Feature-rich **Neovim** setup for coding, with audio programming focus
- **SuperCollider** integration for sound design and algorithmic composition
- **AI-assisted coding** with local models via Ollama and Claude API
- Secure credential management via Bitwarden
- Productivity tools like **zoxide**, **eza**, and more

## Terminal Environment

### Wezterm Configuration (`wezterm/.wezterm.lua`)

Modern GPU-accelerated terminal emulator with:

- **Catppuccin Mocha** colorscheme for a pleasant visual experience
- **Victor Mono** font with fallbacks to Nerd Font symbols
- Integrated with **tmux** as default shell for session persistence
- Customized window decorations optimized for macOS
- Enhanced hyperlink handling with Ctrl+click activation
- Simplified tab and window management without confirmation dialogs

### Tmux Configuration (`tmux/.tmux.conf`)

Terminal multiplexer for session management with:

- **Prefix key remapped** to Ctrl+s for ergonomic access
- **Vim-like pane navigation** (h,j,k,l) for seamless movement
- **Split window shortcuts** (| and -) preserving working directory
- **Mouse support** with enhanced selection and scrolling
- **Vim-like copy mode** with system clipboard integration
- Tight integration with Neovim via vim-tmux-navigator
- Tokyo Night theme for consistent aesthetics
- Session auto-termination when detached (clean workspace)

### Shell Configuration

#### Bash Configuration (`bash/.bashrc`)
- **Starship prompt** with custom symbols and git integration
- **eza** with icons for enhanced file listings
- **zoxide** for smart directory jumping (`z` and `cv` commands)
- **tmuxifier** for tmux workspace management
- **thefuck** for command correction
- Environment setup for Haskell (ghcup), Go, and secure API keys

#### Zsh Configuration (`zsh/.zshrc`)
- **Python environment** setup with pyenv and Miniconda
- Same terminal enhancements as bash
- More modern shell with improved completion system
- Nearly identical aliases and functions as bash for consistency

### Starship Prompt (`starship/starship.toml`)

Customized prompt featuring:

- OS-specific icons (🍏 for macOS, 🐧 for Linux)
- Directory display with custom icons for common folders
- Git branch (🌿) and status indicators with emoji
- Language version indicators (🐍 Python, 🦀 Rust, 🐹 Go)
- System resource monitoring (🧠 memory usage)
- Battery status with contextual icons (🔋⚡️💨)
- Time display with timestamp formatting
- Emoticon-based success/error indicators

## Neovim Configuration

A powerful code editor setup focused on audio programming and development efficiency.

### Core Features

- **lazy.nvim** plugin manager with modular configuration
- **Multiple colorscheme options**:
  - Catppuccin (primary) with mocha flavor
  - Moonfly (secondary) with terminal color integration
- **File navigation**:
  - Neo-tree file explorer with git status integration
  - Telescope fuzzy finder for files, grep, buffers
  - Alpha-nvim dashboard for quick access to recent files
- **Status line**: Lualine with custom theming and git integration
- **Language support** via Treesitter for 12+ languages including:
  - Lua, JavaScript, Python, Rust, HTML/CSS, JSON, Markdown, Bash
- **Git integration** with Gitsigns showing changes in gutter

### AI Integration

#### Ollama Integration (`plugins/ollama.lua`)

Local AI assistance with:

- **Model selection**: mistral (default), phi4, llama3.2
- **Customized prompts** for specific coding tasks:
  - Generate_Code: Creates new code based on description (phi4)
  - Commit_Message: Writes git commit messages (llama3.2)
  - Doc_String: Generates documentation for code (mistral)
  - Explain_Code: Provides explanation of code functionality (phi4)
- **Keybindings**:
  - `<leader>oo`: General AI prompt
  - `<leader>oG`: Generate code
  - `<leader>oC`: Generate commit message
  - `<leader>oD`: Generate docstring
- **Custom parameters** for each model (temperature, top_k, top_p)
- **Network configuration** for remote Ollama server

#### Avante Integration (`plugins/avante.lua`)

Claude-powered code assistance with:

- API integration with Anthropic's Claude 3.7 Sonnet
- Context-aware code suggestions
- Secure API key management via Bitwarden
- Visual selection processing for targeted assistance
- Image clip support for visual documentation

### SuperCollider Integration (`plugins/scnvim.lua`)

Full-featured SuperCollider IDE with:

- **Code evaluation**: Send line, block, or selection to server
- **Post window**: Floating, toggleable feedback display
- **Server control**: Boot, stop, meter controls
- **Documentation**: Quick access to help and signatures
- **Custom keybindings**:
  - Alt+e: Send line
  - Ctrl+e: Send block/selection
  - Enter: Toggle post window
  - F12: Hard stop SuperCollider
  - Leader+st: Start SuperCollider
  - Leader+sk: Recompile class library
  - F1/F2: Boot server/show meters

### LSP Configuration (`plugins/lsp-config.lua`)

Language Server Protocol setup with:

- **Mason** for automated LSP server installation
- **Configured servers** for:
  - lua_ls (Lua)
  - pyright (Python)
  - rust_analyzer (Rust)
  - cssls/html/jsonls (Web development)
  - tailwindcss
  - clangd (C/C++)
- **Keybindings**:
  - K: Hover documentation
  - gd: Go to definition
  - gr: Find references
  - \<leader\>ca: Code actions
  - \<leader\>rn: Rename symbol
  - [d/]d: Navigate diagnostics
- **Completion engine** (nvim-cmp) with:
  - LSP integration
  - Snippet support via LuaSnip
  - Tab/Shift+Tab navigation
  - Visual feedback with Fidget

### Vim Configuration (`vim-options.lua`)

Core editor settings:

- **Leader keys**: Space (leader), \ (localleader)
- **Indentation**: 2-space tabs, expandtab
- **Line numbering**: Relative with current line number
- **Line wrapping**: Enabled with word boundary preservation
- **Search**: Case-insensitive with smart case
- **System clipboard** integration

## Utility Scripts

### `backup-dotfiles.py`

Automated dotfiles management script:

- **Brewfile generation** capturing installed packages
- **Backup system** with timestamped archives
- **Symlink management** for each dotfile package
- **Git integration** for automatic commits and pushes
- **Configuration mapping** for organized deployment

### `restore-dotfiles.py`

System restoration script:

- **Repository cloning** from GitHub
- **Homebrew installation** if needed
- **Package installation** via Brewfile
- **Symlink creation** for each configuration
- **Target directory handling** for special cases

### Shared Scripts

#### `shared/fabric_aliases.sh`

Integration with AI writing tool:

- **Dynamic alias generation** for each pattern file
- **Obsidian integration** with automatic file creation
- **Date stamping** for organization
- **Output modes**: File output or streaming

#### `shared/go_env.sh`

Go language environment setup:

- **GOROOT** pointing to Homebrew Go installation
- **GOPATH** set to ~/go
- **PATH** extension for Go binaries

#### `shared/secure_env.sh`

Secure credential management:

- **Bitwarden integration** with session unlocking
- **API key retrieval** for Anthropic Claude
- **Secure export** to environment variables

## Package Management

### Homebrew Packages (`brew/Brewfile`)

Comprehensive software collection including:

- **Development tools**: git, neovim, rust, python, cmake
- **Audio software**: carla, chuck, csound, supercollider, sonic-pi
- **Productivity**: tmux, starship, zoxide, ripgrep
- **AI tools**: ollama (with service configuration)
- **Creative applications**: blender, gimp, krita, musescore
- **Terminal emulators**: wezterm, alacritty, kitty
- **Fonts**: MesloLGS Nerd Font, Victor Mono

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles

# Run the restore script
cd ~/.dotfiles
python3 restore-dotfiles.py

# Or install manually with stow
cd ~/.dotfiles
stow bash zsh tmux wezterm neovim starship
```

## Requirements

- macOS or Linux
- Git
- Python 3.6+
- Homebrew (for macOS)
- GNU Stow
- Nerd Font compatible terminal
- SuperCollider 3.12+ (for audio programming features)
- Ollama (for local AI assistance)
- Bitwarden CLI (for secure credential management)

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.