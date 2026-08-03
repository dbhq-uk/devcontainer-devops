#!/bin/bash
set -euo pipefail

. "$(dirname "$0")/_arch.sh"

WORKDIR="/tmp/install-kubectl"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Get latest version if not specified
if [ -z "${1:-}" ]; then
    echo "Fetching latest kubectl version..."
    VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt | sed 's/v//')
    echo "Latest version: ${VERSION}"
else
    VERSION=$1
fi

echo "Installing kubectl version ${VERSION}..."

# Download kubectl
curl -LO "https://dl.k8s.io/release/v${VERSION}/bin/linux/${ARCH_DEB}/kubectl"

# Download checksum
curl -LO "https://dl.k8s.io/release/v${VERSION}/bin/linux/${ARCH_DEB}/kubectl.sha256"

# Verify checksum
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# Install kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/

# Verify installation
kubectl version --client

echo "kubectl ${VERSION} installed successfully"
