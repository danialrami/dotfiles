# Dotfiles

![License](https://img.shields.io/badge/license-GPL--3.0-blue)

## 🎯 Multi-Platform Support

This dotfiles repository now supports **multiple machines and operating systems** from a single unified `main` branch using environment detection:

- **macOS** (klaxon) - Full support with Homebrew integration
- **Arch Linux** (siku) - Full support with native tools
- **Other Linux distros** - Extensible (Ubuntu, Fedora, Debian, etc.)

All machines use the same repository. Platform-specific configurations are automatically detected and loaded. See **[MULTIPLATFORM_GUIDE.md](./MULTIPLATFORM_GUIDE.md)** for details.

### Quick Start
```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
python3 restore-dotfiles.py  # Auto-detects platform
```

## Overview

This repository contains configurations for an optimized development environment centered around:

- Modern terminal experience with **tmux**, **Wezterm**, **Ghostty**, and **Starship**
- Feature-rich **Neovim** setup for coding, with audio programming focus
- **SuperCollider** integration for sound design and algorithmic composition
- **AI-assisted coding** with local models via Ollama and Claude API
- Secure credential management via Bitwarden
- Productivity tools like **zoxide**, **eza**, and more
- **Cross-platform support** with automatic environment detection

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

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details# Dotfiles

![License](https://img.shields.io/badge/license-GPL--3.0-blue)

## Overview

This repository contains configurations for an optimized development environment centered around:

- Modern terminal experience with **tmux**, **Wezterm**, **Ghostty**, and **Starship**
- Feature-rich **Neovim** setup for coding, with audio programming focus
- **SuperCollider** integration for sound design and algorithmic composition
- **AI-assisted coding** with local models via Ollama and Claude API
- **Fish shell** with comprehensive function library and modern tooling
- Secure credential management via Bitwarden
- Extensive **audio development** workflows and session management

## Terminal Environment

### Terminal Emulators

#### Wezterm Configuration (`wezterm/.wezterm.lua`)

Modern GPU-accelerated terminal emulator with:

- **Catppuccin Mocha** colorscheme for consistent theming
- **Victor Mono** font with fallbacks to Nerd Font symbols  
- Integrated with **tmux** as default shell for session persistence
- Customized window decorations optimized for macOS
- Enhanced hyperlink handling with Ctrl+click activation
- Simplified tab and window management without confirmation dialogs

#### Ghostty Configuration (`ghostty/config`)

Fast, native terminal emulator featuring:

- **Catppuccin Mocha** color scheme with transparency effects
- **Victor Mono** font at 12pt for optimal readability
- Smart tmux startup script for session management
- Transparent titlebar with macOS integration
- Custom keybindings for tab navigation and quick terminal toggle
- Automatic working directory inheritance

### Tmux Configuration (`tmux/.tmux.conf`)

Terminal multiplexer for session management with:

- **Fish shell** as default with enhanced functionality
- **Prefix key remapped** to Ctrl+s for ergonomic access
- **Vim-like pane navigation** (h,j,k,l) for seamless movement
- **Split window shortcuts** (| and -) preserving working directory
- **Mouse support** with enhanced selection and scrolling
- **Vim-like copy mode** with system clipboard integration
- Tight integration with Neovim via vim-tmux-navigator
- **Tokyo Night theme** for consistent aesthetics
- **Auto-session termination** when detached (clean workspace)

### Shell Configuration

#### Fish Shell (`fish/.config/fish/config.fish`)

Modern shell with extensive function library:

- **Starship prompt** with custom symbols and git integration
- **Tool-specific aliases** with conditional loading:
  - `bat` for enhanced cat with syntax highlighting
  - `eza` with icons for beautiful file listings
  - `rg` (ripgrep) for fast searching
  - `dust` for disk usage visualization
  - `delta` for git diff enhancement
  - `procs` for modern process viewing
- **Audio development shortcuts** for SuperCollider workflows
- **Smart script execution** with `run_script` function

#### Comprehensive Function Library

**File and Directory Operations:**
- `fzf_file` - Interactive file finder with bat preview
- `fzf_dir` - Directory navigation with tree preview  
- `y` (yazi) - File manager with directory changing capability
- `note` - Markdown note taking with preview browsing

**Development Tools:**
- `git_diff_fancy` - Enhanced git diff with delta
- `git_log_fancy` - Interactive git log browser
- `search_replace` - Multi-file search and replace with ripgrep/sd
- `project_stats` - Code metrics and project analysis with tokei
- `run_script` - Universal script runner supporting 20+ file types

**System Utilities:**
- `kill_process` - Interactive process management with fzf
- `disk_analysis` - Disk usage analysis with dust/diskonaut
- `bench` - Command benchmarking with hyperfine
- `check_rust_tools` - Inventory of installed Rust CLI tools

**Audio Development:**
- `audio_session` - Dedicated tmux session for audio work
- `yt` - YouTube transcript extraction with fabric
- `fabric_setup` - AI writing pattern integration

#### Legacy Shell Support

**Bash Configuration (`bash/.bashrc`):**
- Complete function library mirrored from Fish
- **Python environment** setup with pyenv
- **Go environment** configuration
- **Fabric AI integration** for writing workflows
- Nearly identical functionality to Fish for consistency

**Zsh Configuration (`zsh/.zshrc`):**
- **Python environment** setup with pyenv and Miniconda
- Streamlined configuration focusing on essential tools
- Same terminal enhancements as other shells

### Starship Prompt (`starship/starship.toml`)

Customized prompt featuring:

- **OS-specific icons** (🍏 for macOS, 🐧 for Linux)
- **Smart directory display** with custom icons:
  - 📄 Documents, 📥 Downloads, 🎵 Music
  - 💎 ore (projects), 👩‍💻 Developer directories
- **Git integration** with branch (🌿) and status indicators
- **Language version indicators** (🐍 Python, 🦀 Rust, 🐹 Go)
- **System monitoring** (🧠 memory usage, 🔋 battery status)
- **Time display** with full timestamp formatting
- **Emoticon-based** success/error indicators (👉/😵)

## Neovim Configuration

A powerful code editor setup optimized for audio programming and development efficiency.

### Core Features

- **lazy.nvim** plugin manager with modular configuration
- **Multiple colorscheme options**:
  - **Catppuccin** (primary) with mocha flavor and transparency options
  - **Moonfly** (secondary) with terminal color integration
- **Enhanced file navigation**:
  - **Neo-tree** file explorer with git status integration
  - **Telescope** fuzzy finder for files, grep, buffers with UI select
  - **Alpha-nvim** dashboard for quick access to recent files
- **Status line**: **Lualine** with moonfly theming and git integration
- **Language support** via **Treesitter** for 12+ languages
- **Git integration** with **Gitsigns** showing changes in gutter

### AI Integration

#### Ollama Integration (`plugins/ollama.lua`)

Local AI assistance with network support:

- **Remote server configuration** (http://siku.local:11434)
- **Multiple model support**: mistral (default), phi4, llama3.2
- **Specialized prompts** for development tasks:
  - **Generate_Code**: Creates new code based on description (phi4)
  - **Commit_Message**: Writes git commit messages (llama3.2)  
  - **Doc_String**: Generates documentation for code (mistral)
  - **Explain_Code**: Provides code functionality explanation (phi4)
- **Keybindings**:
  - `<leader>oo`: General AI prompt
  - `<leader>oG`: Generate code
  - `<leader>oC`: Generate commit message
  - `<leader>oD`: Generate docstring
- **Custom model parameters** (temperature, top_k, top_p)

#### Avante Integration (`plugins/avante.lua`)

Claude-powered code assistance with:

- **Claude 3.7 Sonnet** API integration
- **Advanced features**:
  - Context-aware code suggestions
  - Image clip support for visual documentation
  - Render markdown preview for documentation
  - Integration with telescope and fzf-lua
- **Secure API key management** via environment variables

#### Copilot Integration (`plugins/copilot.lua`)

GitHub Copilot support with:

- **Auto-trigger suggestions** with 75ms debounce
- **Custom keybindings**:
  - `<M-l>`: Accept suggestion
  - `<M-]>/<M-[>`: Navigate suggestions
  - `<C-]>`: Dismiss suggestions
- **Panel mode** for code exploration and refinement
- **Selective file type support** (disabled for markdown, yaml)

### SuperCollider Integration (`plugins/scnvim.lua`)

Full-featured SuperCollider IDE with:

- **Real-time code evaluation**: Send line, block, or selection to server
- **Floating post window** with toggle functionality
- **Server control**: Boot, stop, recompile, meter controls
- **Documentation access**: Quick help and signature lookup
- **Enhanced keybindings**:
  - `<M-e>`: Send line (insert/normal mode)
  - `<C-e>`: Send block/selection
  - `<M-o>`: Toggle post window
  - `<F12>`: Hard stop SuperCollider
  - `<leader>st>/<leader>sk>`: Start/recompile
  - `<F1>/<F2>`: Boot server/show meters
- **Syntax highlighting** with IncSearch color scheme

### Development Tools

#### LSP Configuration (`plugins/lsp-config.lua`)

Language Server Protocol setup with:

- **Mason** for automated LSP server installation
- **Comprehensive language support**:
  - lua_ls (Lua), pyright (Python), rust_analyzer (Rust)
  - cssls/html/jsonls (Web), tailwindcss, clangd (C/C++)
- **Enhanced completion** with nvim-cmp:
  - LSP integration with intelligent suggestions
  - Snippet support via LuaSnip with friendly-snippets
  - Tab/Shift+Tab navigation
  - Visual feedback with Fidget progress indicators

#### Testing Integration (`plugins/vim-test.lua`)

Testing workflow with:

- **Vimux integration** for test output in tmux pane
- **Comprehensive keybindings**:
  - `<leader>t`: Run nearest test
  - `<leader>T`: Run test file
  - `<leader>a`: Run full test suite
  - `<leader>l`: Run last test
  - `<leader>g`: Visit test file

#### Navigation Enhancement

- **vim-tmux-navigator** for seamless tmux/nvim pane navigation
- **Dressing.nvim** for enhanced UI elements with telescope backend
- **Telescope-ui-select** for consistent selection interface

### Editor Configuration (`vim-options.lua`)

Optimized settings for development:

- **Leader keys**: Space (leader), \ (localleader)
- **Smart indentation**: 2-space tabs with expandtab
- **Enhanced line handling**: Relative numbering with current line
- **Intelligent search**: Case-insensitive with smart case override
- **Word-boundary wrapping** for improved readability
- **System clipboard** integration
- **VSCode compatibility** mode for extension use

## Audio Development Workflows

### Dedicated Audio Session Management

**Audio Session Function** (`audio_session.fish`):

- **Organized tmux workspace** for audio development
- **Predefined windows**:
  - **main**: General terminal in audio projects directory
  - **sc**: SuperCollider development environment  
  - **daw**: DAW and audio tool launcher
  - **monitor**: System monitoring (htop, resource usage)
- **JACK daemon detection** and status reporting
- **Project directory management** (~/Audio/Projects)

### SuperCollider Integration

- **Full IDE experience** within Neovim via scnvim
- **Real-time code evaluation** with immediate feedback
- **Server management** with boot/stop controls
- **Post window** for sclang output and error messages

### Audio Tool Support

**Comprehensive audio application support** via Homebrew:

- **DAWs and Sequencers**: Mixxx for DJ workflows
- **Sound Design**: SuperCollider, Sonic Pi, Chuck, Csound
- **Audio Processing**: Carla (plugin host), Audacity, Ocenaudio
- **Creative Coding**: Pure Data (Pd), PlugData
- **Music Notation**: LilyPond, MuseScore, Frescobaldi
- **Hardware Interface**: MIDI Monitor, SysEx Librarian

## Utility Scripts

### Dotfiles Management

#### `backup-dotfiles.py`

Automated backup and sync system:

- **Brewfile generation** capturing all installed packages
- **Timestamped backup system** for existing configurations
- **Intelligent symlink management** for each package
- **Git automation** for commits and pushes
- **Organized package mapping** for deployment

#### `restore-dotfiles.py`

Complete system restoration:

- **Repository cloning** with latest updates
- **Homebrew installation** and package restoration
- **Symlink creation** with proper target directory handling
- **Configuration deployment** for immediate usability

### Shared Environment Configuration

#### `shared/fabric_aliases.sh`

AI writing integration:

- **Dynamic alias generation** for each fabric pattern
- **Obsidian integration** with automatic file creation in organized structure
- **Date stamping** and file organization
- **Flexible output modes**: File output or streaming

#### Environment Setup Scripts

**Go Environment** (`shared/go_env.sh/.fish`):
- **GOROOT** pointing to Homebrew Go installation
- **GOPATH** configuration for Go workspace
- **PATH** extension for Go binaries

**Secure Environment** (`shared/secure_env.sh/.fish`):
- **Bitwarden CLI integration** (commented template)
- **API key management** for Anthropic Claude
- **Secure credential handling** patterns

## Package Management

### Homebrew Configuration (`brew/Brewfile`)

Comprehensive software ecosystem including:

**Development Tools:**
- Core: git, neovim, rust, python, go, cmake, protobuf
- Modern CLI: ripgrep, fd, eza, zoxide, starship, yazi
- Languages: pyenv, uv (Python), hugo (Go), tcl-tk

**Audio Software:**
- Production: carla, chuck, csound, supercollider, sonic-pi
- Tools: audacity, hydrogen, milkytracker, mixxx
- Creative: musescore, lilypond, frescobaldi
- Hardware: midi-monitor, sysex-librarian

**Terminal and Development:**
- Emulators: wezterm, alacritty, kitty, ghostty
- Shell: tmux, bash, fish (via tmux config)
- Multiplexers: tmux with plugin ecosystem

**Creative Applications:**
- 3D/Design: blender, gimp, krita, inkscape
- Office: libreoffice, calibre
- Media: vlc, ffmpeg, handbrake

**System and Productivity:**
- Security: bitwarden, mullvadvpn, gpg-suite
- Network: tailscale, cyberduck, angry-ip-scanner
- Storage: nextcloud, syncthing, veracrypt

**Fonts:**
- Development: font-meslo-lg-nerd-font, font-victor-mono
- Complete Nerd Font symbol support

### VSCodium Integration

**Settings Configuration** (`vscodium/settings.json`):

- **Neovim integration** with proper executable paths
- **Catppuccin theming** for consistency across tools
- **Advanced terminal profiles**:
  - tmux-workspace: Project-specific sessions
  - tmux-main: General development session
  - fish/zsh/bash: Direct shell access
- **Git workflow optimization** with smart commit and autofetch
- **Font configuration** matching terminal setup

## Installation

### Quick Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles

# Run the automated restore script
cd ~/.dotfiles
python3 restore-dotfiles.py
```

### Manual Installation

```bash
# Install individual packages with stow
cd ~/.dotfiles
stow bash fish zsh tmux wezterm ghostty neovim starship

# Install Homebrew packages
brew bundle --file=brew/Brewfile

# Set up fish shell (if desired)
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### Audio Development Setup

```bash
# Create audio session
audio_session

# Install SuperCollider (if not via Homebrew)
# Download from: https://supercollider.github.io/

# Configure JACK for low-latency audio
# Install JackPilot or use QjackCtl
```

## Requirements

### System Requirements
- **macOS** 10.15+ or **Linux** (Ubuntu 20.04+/Arch/Fedora)
- **Git** 2.20+
- **Python** 3.8+
- **Homebrew** (macOS) or equivalent package manager

### Development Tools
- **GNU Stow** for symlink management
- **Nerd Font** compatible terminal emulator
- **tmux** 3.0+ for session management

### Audio Development (Optional)
- **SuperCollider** 3.12+ for audio programming
- **JACK Audio** for low-latency audio routing
- **Audio interface** or built-in audio for basic workflows

### AI Integration (Optional)
- **Ollama** for local AI assistance
- **Anthropic API key** for Claude integration
- **Bitwarden CLI** for secure credential management

## Features by Use Case

### Audio Professionals
- **Dedicated audio session management** with tmux
- **SuperCollider IDE** integration in Neovim
- **JACK-aware** workflows and monitoring
- **Comprehensive audio tool** installation via Brewfile
- **MIDI and hardware** interface tools

### Software Developers  
- **Multi-language LSP** support with intelligent completion
- **AI-assisted coding** with Ollama and Claude
- **Advanced git workflows** with delta and interactive tools
- **Testing integration** with vim-test and vimux
- **Project analysis tools** with tokei and fd

### System Administrators
- **Comprehensive CLI tooling** with modern Rust replacements
- **System monitoring** integrated into workflows
- **Secure credential management** patterns
- **Cross-platform compatibility** (macOS/Linux)
- **Automated deployment** and backup systems

### Creative Professionals
- **Note-taking workflows** with markdown and preview
- **AI writing assistance** via fabric integration
- **Creative application suite** via Homebrew
- **Version control** for creative projects
- **Cross-platform font** and theming consistency
## Multi-Platform Architecture

This repository now features a **unified architecture** that supports multiple machines and operating systems:

### Environment Detection
Automatic platform detection via `scripts/detect-env.sh`:
- Detects OS (macOS, Linux)
- Identifies Linux distro (Arch, Ubuntu, Fedora, Debian, etc.)
- Sets environment variables: `DOTFILES_OS`, `DOTFILES_DISTRO`, `DOTFILES_HOSTNAME`

### Modular Configuration
Configurations are split into common and platform-specific variants:

- **Starship Prompt**: `starship.common.toml` + `starship.darwin.toml` + `starship.arch.toml`
- **Fish Shell**: `config.fish` with `conf.d/` modular structure
  - `00-environment.fish` - Common setup
  - `01-platform.fish` - Platform-specific
  - `02-tools.fish` - Tool initialization
- **Neovim**: Per-platform plugin lock files (`lazy-lock.darwin.json`, `lazy-lock.arch.json`)

### Platform-Aware Scripts
Both backup and restore scripts automatically:
- Detect current OS/distro
- Filter packages for that platform
- Use appropriate package managers
- Generate platform-specific commit messages

### Testing
Comprehensive test suite with 34 passing tests:
- **19 unit tests** - Environment detection
- **15 integration tests** - Architecture validation

Run tests:
```bash
cd ~/.dotfiles
python3 -m unittest tests.test_detect_env tests.test_integration -v
```

## Documentation

- **[MULTIPLATFORM_GUIDE.md](./MULTIPLATFORM_GUIDE.md)** - Comprehensive architecture and usage guide
- **[GIT_STRATEGY.md](./GIT_STRATEGY.md)** - Branch strategy and workflow
- **[IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md)** - Complete implementation details
- **[SETUP_GUIDE.md](./SETUP_GUIDE.md)** - Daily workflow and troubleshooting
- **[OPENCODE_INTEGRATION.md](./OPENCODE_INTEGRATION.md)** - OpenCode configuration integration

## Deployment

### First Time Setup

**macOS:**
```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
python3 restore-dotfiles.py
source ~/.dotfiles/scripts/init-nvim-lockfile.sh
```

**Arch Linux:**
```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
python3 restore-dotfiles.py
source ~/.dotfiles/scripts/init-nvim-lockfile.sh
```

### Updating Dotfiles

On any machine, pull latest and backup/update configs:
```bash
cd ~/.dotfiles
git pull origin main
python3 backup-dotfiles.py  # Auto-detects platform
```

Platform-specific configs automatically apply based on detected OS/distro.

---

**Status**: ✅ Production Ready  
**Supported Platforms**: macOS (Darwin), Arch Linux, extensible to others  
**Test Coverage**: 34 passing tests (unit + integration)  
**Last Updated**: October 2025
