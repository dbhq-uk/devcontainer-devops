#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-helm"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Get latest version if not specified
if [ -z "${1:-}" ]; then
    echo "Fetching latest Helm version..."
    VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    echo "Latest version: ${VERSION}"
else
    VERSION=$1
fi

echo "Installing Helm version ${VERSION}..."

# Download Helm
curl -LO "https://get.helm.sh/helm-v${VERSION}-linux-amd64.tar.gz"

# Download checksum
curl -LO "https://get.helm.sh/helm-v${VERSION}-linux-amd64.tar.gz.sha256sum"

# Verify checksum
# sha256sum -c helm-v${VERSION}-linux-amd64.tar.gz.sha256sum

# Extract and install
tar -zxvf helm-v${VERSION}-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm

# Verify installation
helm version

echo "Helm ${VERSION} installed successfully"
