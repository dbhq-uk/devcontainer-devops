#!/bin/bash
set -euo pipefail

echo "Installing Claude Code using native installer..."

# Install Claude Code using the official native installer
curl -fsSL https://claude.ai/install.sh | bash

# Add install location to PATH and verify installation
export PATH="$HOME/.local/bin:$PATH"
claude --version

# Make claude available system-wide (installer puts it in root's ~/.local/bin,
# but the container runs as the vscode user)
ln -sf "$HOME/.local/bin/claude" /usr/local/bin/claude

echo "Claude Code installed successfully"
