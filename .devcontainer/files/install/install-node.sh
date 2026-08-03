#!/bin/bash
set -euo pipefail

echo "Installing Node.js..."

# Default to LTS version 24 if not specified
NODE_MAJOR="${1:-24}"

echo "Installing Node.js ${NODE_MAJOR}.x..."

# Add NodeSource GPG key and repository
curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash -

# Install Node.js (includes npm)
apt-get install -y --no-install-recommends nodejs

# Upgrade npm to fix GHSA-3966-f6p6-2qr9 (high — local privilege escalation in npm 10.9.8)
npm install -g npm@latest

# Clean up apt cache
apt-get autoremove --purge -y
rm -rf /var/lib/apt/lists/*

# Verify installation
node --version
npm --version

echo "Node.js installed successfully"
