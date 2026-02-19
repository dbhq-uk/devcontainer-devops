#!/bin/bash
set -euo pipefail

echo "Installing git-crypt..."

# Install dependencies
apt-get update
apt-get install -y git-crypt

# Verify installation
git-crypt --version

echo "git-crypt installed successfully"
