#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-kubelogin"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Get latest version if not specified
if [ -z "${1:-}" ]; then
    echo "Fetching latest kubelogin version..."
    VERSION=$(curl -sI https://github.com/Azure/kubelogin/releases/latest | grep -i '^location:' | sed -E 's|.*/v([^[:space:]]+).*|\1|')
    if [ -z "${VERSION}" ]; then
        echo "ERROR: Failed to determine latest kubelogin version"
        exit 1
    fi
    echo "Latest version: ${VERSION}"
else
    VERSION=$1
fi

echo "Installing kubelogin version ${VERSION}..."

# Download kubelogin
curl -LO "https://github.com/Azure/kubelogin/releases/download/v${VERSION}/kubelogin-linux-amd64.zip"

# Extract and install
unzip kubelogin-linux-amd64.zip
chmod +x bin/linux_amd64/kubelogin
mv bin/linux_amd64/kubelogin /usr/local/bin/

# Verify installation
kubelogin --version

echo "kubelogin ${VERSION} installed successfully"
