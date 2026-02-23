#!/bin/bash
set -euo pipefail

echo "Installing Claude Code..."

# Install specific version if provided, otherwise install latest
if [ -n "${1:-}" ]; then
    echo "Installing Claude Code version ${1}..."
    npm install -g "@anthropic-ai/claude-code@${1}"
else
    echo "Installing latest Claude Code..."
    npm install -g @anthropic-ai/claude-code
fi

# Verify installation
claude --version

echo "Claude Code installed successfully"
