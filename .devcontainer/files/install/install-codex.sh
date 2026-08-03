#!/bin/bash
set -euo pipefail

echo "Installing Codex..."

if [ -n "${1:-}" ]; then
    echo "Installing Codex version ${1}..."
    npm install -g "@openai/codex@${1}"
else
    echo "Installing latest Codex..."
    npm install -g @openai/codex
fi

codex --version

echo "Codex installed successfully"
