#!/bin/bash
set -e

WORKDIR="/tmp/install-tflint"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Get latest version if not specified
if [ -z "$1" ]; then
    echo "Fetching latest tflint version..."
    VERSION=$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
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
