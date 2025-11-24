#!/bin/bash
set -e

# Get latest version if not specified
if [ -z "$1" ]; then
    echo "Fetching latest kubelogin version..."
    VERSION=$(curl -s https://api.github.com/repos/Azure/kubelogin/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
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

# Cleanup
#rm -rf bin kubelogin-linux-amd64.zip

# Verify installation
kubelogin --version

echo "kubelogin ${VERSION} installed successfully"
