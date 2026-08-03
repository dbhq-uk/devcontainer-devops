#!/bin/bash
set -euo pipefail

echo "Installing git-crypt..."

# Install dependencies
apt-get update
apt-get install -y --no-install-recommends git-crypt
rm -rf /var/lib/apt/lists/*

# Verify installation
git-crypt --version

echo "git-crypt installed successfully"
