#!/bin/bash
set -euo pipefail

# claude-swap (`cswap`) — multi-account switcher for Claude Code.
# https://github.com/realiti4/claude-swap
#
# Installed system-wide (not into ~/.local) on purpose: /home/vscode is a
# named volume that only gets seeded from /tmp-home on first container start,
# so a home-tree install would go stale for anyone with an existing volume.
# The console script lands in /usr/local/bin and operates on whatever
# $CLAUDE_CONFIG_DIR / $HOME the invoking user has at runtime.
#
# Pure-Python wheel (py3-none-any); on Linux it pulls only textual + truststore.
# Requires Python >= 3.12 — Ubuntu 24.04 ships 3.12, so no extra runtime needed.

# Get latest version if not specified
if [ -z "${1:-}" ]; then
    echo "Fetching latest claude-swap version..."
    VERSION=$(curl -s https://pypi.org/pypi/claude-swap/json | jq -r '.info.version')
    if [ -z "${VERSION}" ] || [ "${VERSION}" = "null" ]; then
        echo "ERROR: Failed to determine latest claude-swap version"
        exit 1
    fi
    echo "Latest version: ${VERSION}"
else
    VERSION=$1
fi

echo "Installing claude-swap version ${VERSION}..."

python3 -m pip install --no-cache-dir claude-swap==${VERSION}

# Verify installation
cswap --version

echo "claude-swap ${VERSION} installed successfully (command: cswap)"
