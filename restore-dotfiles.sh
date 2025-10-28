#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${DOTFILES_DIR}/.venv"
PYTHON_SCRIPT="${DOTFILES_DIR}/restore-dotfiles.py"

setup_venv() {
    if [ ! -d "${VENV_DIR}" ]; then
        echo "[INFO] Creating virtual environment..."
        python3 -m venv "${VENV_DIR}"
    fi

    echo "[INFO] Activating virtual environment..."
    source "${VENV_DIR}/bin/activate"

    echo "[INFO] Installing dependencies..."
    pip install --upgrade pip setuptools wheel > /dev/null 2>&1
    if [ -f "${DOTFILES_DIR}/requirements.txt" ]; then
        pip install -r "${DOTFILES_DIR}/requirements.txt" > /dev/null 2>&1
    fi
}

main() {
    setup_venv
    python3 "${PYTHON_SCRIPT}" "$@"
}

main "$@"
