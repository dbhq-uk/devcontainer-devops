#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-yq"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Get latest version if not specified
if [ -z "${1:-}" ]; then
    echo "Fetching latest yq version..."
    VERSION=$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    echo "Latest version: ${VERSION}"
else
    VERSION=$1
fi

echo "Installing yq version ${VERSION}..."

# Download yq
YQ_BINARY="yq_linux_amd64"
DOWNLOAD_URL="https://github.com/mikefarah/yq/releases/download/v${VERSION}/${YQ_BINARY}"

echo "Downloading from: $DOWNLOAD_URL"
curl -L "$DOWNLOAD_URL" -o yq

# Download checksum and verify
curl -L "https://github.com/mikefarah/yq/releases/download/v${VERSION}/checksums" -o checksums

CHECKSUM="$(sha256sum yq | awk '{print $1}')"
# Extract the 64-char hex hash matching the exact binary name (not .tar.gz variant)
EXPECTED_CHECKSUM="$(grep -E "(^|[[:space:]])${YQ_BINARY}([[:space:]]|$)" checksums | grep -oE '[a-f0-9]{64}' | head -1)"

if [ -z "${EXPECTED_CHECKSUM}" ]; then
    echo "ERROR: Could not find checksum for ${YQ_BINARY} in checksums file"
    echo "Checksums file contents:"
    cat checksums
    exit 1
fi

if [ "$CHECKSUM" == "$EXPECTED_CHECKSUM" ]; then
    echo "Checksum verified successfully"
else
    echo "ERROR: Checksum mismatch! Expected: ${EXPECTED_CHECKSUM}, Got: ${CHECKSUM}"
    exit 1
fi

# Make it executable and move to /usr/local/bin
chmod +x yq
mv yq /usr/local/bin/yq

# Verify installation
yq --version

echo "yq ${VERSION} installed successfully"
