#!/bin/bash
set -euo pipefail

# Get latest version if not specified
if [ -z "${1:-}" ]; then
    echo "Fetching latest checkov version..."
    VERSION=$(curl -s https://pypi.org/pypi/checkov/json | jq -r '.info.version')
    echo "Latest version: ${VERSION}"
else
    VERSION=$1
fi

echo "Installing checkov version ${VERSION}..."

# Install checkov using pip
python3 -m pip install checkov==${VERSION}

# Verify installation
checkov --version

echo "checkov ${VERSION} installed successfully"
