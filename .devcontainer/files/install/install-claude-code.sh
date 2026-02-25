#!/bin/bash
set -euo pipefail

echo "Installing Claude Code using native installer..."

# Install Claude Code using the official native installer
curl -fsSL https://claude.ai/install.sh | sh

# Verify installation
claude --version

echo "Claude Code installed successfully"
