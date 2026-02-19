#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-tflint"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Get latest version if not specified
if [ -z "${1:-}" ]; then
    echo "Fetching latest tflint version..."
    # Use redirect-based lookup to avoid GitHub API rate limits
    VERSION=$(curl -sI https://github.com/terraform-linters/tflint/releases/latest | grep -i '^location:' | sed -E 's|.*/v([^[:space:]]+).*|\1|')
    if [ -z "${VERSION}" ]; then
        echo "ERROR: Failed to determine latest tflint version (possible rate limit)"
        exit 1
    fi
    echo "Latest version: ${VERSION}"
else
    VERSION=$1
fi

echo "Installing tflint version ${VERSION}..."

# Download tflint
curl -L "https://github.com/terraform-linters/tflint/releases/download/v${VERSION}/tflint_linux_amd64.zip" -o tflint.zip

# Extract and install
unzip tflint.zip
chmod +x tflint
mv tflint /usr/local/bin/

# Verify installation
tflint --version

echo "tflint ${VERSION} installed successfully"
