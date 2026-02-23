#!/bin/bash
set -euo pipefail

echo "Installing Node.js..."

# Default to LTS version 22 if not specified
NODE_MAJOR="${1:-22}"

echo "Installing Node.js ${NODE_MAJOR}.x..."

# Add NodeSource GPG key and repository
curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash -

# Install Node.js (includes npm)
apt-get install -y --no-install-recommends nodejs

# Clean up apt cache
apt-get autoremove --purge -y
rm -rf /var/lib/apt/lists/*

# Verify installation
node --version
npm --version

echo "Node.js installed successfully"
