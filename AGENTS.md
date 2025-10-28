# Agent Guidelines for .dotfiles Repository

## 🏗️ Project Overview
Multi-platform dotfiles (macOS/Arch Linux) with environment detection, package management, and configuration deployment via GNU Stow.

## ⚙️ Build & Test Commands

### Python Testing (Primary)
```bash
python3 -m unittest tests.test_detect_env tests.test_integration -v
python3 -m unittest tests.test_detect_env.TestEnvironmentDetector.test_detect_os_darwin -v  # Single test
```
**Location**: `tests/` directory with 34+ passing tests.

### Shell Script Testing
Manually verify deployment with: `./restore-dotfiles.sh` (full workflow) or `./backup-dotfiles.sh` (git commit).

## 📋 Code Style Guidelines

### Python (Primary Language)
- **Imports**: Standard library first, third-party after (e.g., `sys`, `os`, `subprocess`, `pathlib`)
- **Types**: No type hints (write readable vanilla Python)
- **Formatting**: PEP8 style, 4-space indentation, no trailing spaces
- **Error Handling**: Use try/except with specific exceptions; return `None` or default on failure
- **Docstrings**: Single-line docstrings for functions (see `backup-dotfiles.py:run_command()`)
- **Naming**: snake_case for functions/variables (e.g., `run_command`, `DOTFILES_DIR`)
- **Classes**: CamelCase for class names (e.g., `EnvironmentDetector`)

### Shell Scripts
- **Style**: Bash, `set -euo pipefail` for safety
- **Functions**: snake_case (e.g., `setup_venv`, `detect_os`)
- **Quoting**: Always quote variables (`"${VAR}"`)
- **Comments**: Minimal; code is self-documenting

### Configuration Files
- **TOML/JSON**: Follow existing format (see `opencode/` and `brew/`)
- **Fish Shell**: Modular conf.d structure under `fish/.config/fish/`
- **Neovim**: Per-platform lock files (lazy-lock.darwin.json, lazy-lock.arch.json)

## 🔧 Key Patterns & Conventions

### Environment Detection
- Use `detect_env.py:EnvironmentDetector` for platform detection
- Always check `DOTFILES_OS` and `DOTFILES_DISTRO` environment variables
- Supported distros: `darwin`, `macos`, `arch`, `ubuntu`, `fedora`, `debian`

### Deployment
- Use GNU Stow for symlink creation (see `STOW_PACKAGES` dict in restore/backup scripts)
- Package target format: `"package_name": "~/.config"` (e.g., `"neovim": "~/.config"`)

### Error Handling
- Return `None` or "unknown" on failures (see `detect_hostname()` fallback patterns)
- Use descriptive error messages with `[INFO]`, `[ERROR]` prefixes in scripts
- Catch `subprocess.CalledProcessError` for command execution failures

## 📁 Important Paths
- **Main Scripts**: `restore-dotfiles.sh`, `backup-dotfiles.py`, `scripts/detect_env.py`
- **Tests**: `tests/test_detect_env.py`, `tests/test_integration.py`
- **Docs**: `docs/MULTIPLATFORM_GUIDE.md`, `docs/SETUP_GUIDE.md`
- **Configs**: `bash/`, `fish/`, `neovim/`, `starship/`, `opencode/`

## ✅ Before Committing
1. Ensure all tests pass: `python3 -m unittest tests.test_detect_env tests.test_integration -v`
2. Follow PEP8 (no linter configured)
3. Test deployment: `./restore-dotfiles.sh --help` (or run on test system)
4. Update relevant docs if architecture changes
