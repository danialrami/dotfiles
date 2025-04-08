# Dotfiles

## Shell Configuration

### `bash/.bashrc`
- Sources environment files (ghcup, fabric aliases, Go environment, secure environment)
- Sets up Starship prompt for a customized terminal appearance
- Configures eza (modern ls replacement) with icons and directory grouping
- Sets locale to US English
- Configures zoxide (smarter cd) with alias 'cv'
- Sets up tmuxifier for tmux management
- Adds "thefuck" command correction tool

### `zsh/.zshrc`
- Sets up Python environment with pyenv
- Configures Miniconda Python distribution
- Sources the same shared environment files as bash
- Includes identical terminal enhancements (Starship, eza, zoxide, tmuxifier)
- Notably doesn't include "thefuck" unlike bash config

## Shared Scripts

### `shared/fabric_aliases.sh`
- Dynamically creates aliases for each pattern file in ~/.config/fabric/patterns/
- Creates corresponding functions that can output to Obsidian vault with date stamps
- Supports both file output mode and streaming mode

### `shared/go_env.sh`
- Configures GOROOT to point to Homebrew Go installation
- Sets GOPATH to ~/go
- Adds Go binaries to PATH

### `shared/secure_env.sh`
Manages secure credentials:
- Unlocks Bitwarden password manager if needed
- Retrieves and exports Anthropic Claude API key securely from Bitwarden

# Neovim Configuration

Neovim configuration focused on development with fuzzy finding, LSP integration, SuperCollider audio programming, and AI-assisted coding.

## Plugin List

### Core Plugins
- **lazy.nvim** - Plugin manager
- **catppuccin** - Color scheme  
- **lualine.nvim** - Status line
- **neo-tree** - File explorer
- **telescope.nvim** - Fuzzy finder
- **nvim-treesitter** - Syntax highlighting
- **mason.nvim** - LSP package manager
- **dressing.nvim** - Enhanced UI for inputs
- **ollama.nvim** - AI assistance integration
- **avante.nvim** - AI-powered code suggestions (Cursor IDE-style)
- **scnvim** - SuperCollider IDE integration

### LSP & Completion
- **nvim-lspconfig** - LSP configuration
- **mason-lspconfig** - Bridge between mason and lspconfig  
- **nvim-cmp** - Completion engine
- **LuaSnip** - Snippet engine

## Keybindings

### General Navigation
- `Space` - Leader key
- `\` - Local leader key
- `Ctrl + n` - Toggle Neo-tree file explorer
- `Ctrl + p` - Telescope file finder

### AI Assistance
- `<leader>oo` - Open Ollama prompt
- `<leader>oG` - Generate code with Ollama
- `Ctrl + Space` - Trigger AI completions (avante.nvim)

### SuperCollider (scnvim)
- `<M-e>` - Send current line (insert/normal mode)
- `<C-e>` - Send code block or visual selection
- `<Enter>` - Toggle post window
- `<M-CR>` - Toggle post window (insert mode)  
- `<M-L>` - Clear post window
- `<C-k>` - Show function signatures
- `<F12>` - Hard stop SuperCollider
- `<leader>st` - Start SuperCollider
- `<leader>sk` - Recompile class library
- `<F1>` - Server boot (s.boot)
- `<F2>` - Show server meter (s.meter)

### LSP & Diagnostics  
- `K` - Hover documentation
- `gd` - Go to definition
- `gr` - Find references
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol  
- `[d`/`]d` - Navigate diagnostics

### Completion Engine
- `Tab`/`Shift+Tab` - Cycle suggestions
- `Ctrl + b/f` - Scroll docs
- `Ctrl + e` - Close completion
- `Enter` - Confirm selection

## Language Support

### Configured Servers
- Lua
- Python  
- Rust
- C/C++
- HTML/CSS
- JSON
- Tailwind CSS
- **SuperCollider** (via scnvim integration)

### Specialized Integration
- **AI Autocomplete**: avante.nvim provides context-aware code suggestions through neural network models
- **Audio Programming**: Full SuperCollider IDE features including:
  - Post window in floating buffer
  - Snippet generation for SC class methods
  - Server status monitoring
  - Interactive help system

## Requirements

- Neovim ≥ 0.9.0
- Nerd Font (icons)
- ripgrep (telescope)
- Ollama local server
- SuperCollider ≥ 3.12
- Rust toolchain (avante.nvim)