#!/bin/bash
# Install pre-commit framework

set -e

echo "Installing pre-commit framework..."

# Install pre-commit via pip
python3 -m pip install pre-commit

# Verify installation
pre-commit --version

echo "pre-commit framework installed successfully"
echo "Run 'pre-commit install' in your repository to enable hooks"
