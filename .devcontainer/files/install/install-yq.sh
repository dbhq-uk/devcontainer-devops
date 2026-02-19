#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-yq"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Get latest version if not specified
if [ -z "${1:-}" ]; then
    echo "Fetching latest yq version..."
    VERSION=$(curl -sI https://github.com/mikefarah/yq/releases/latest | grep -i '^location:' | sed -E 's|.*/v([^[:space:]]+).*|\1|')
    if [ -z "${VERSION}" ]; then
        echo "ERROR: Failed to determine latest yq version"
        exit 1
    fi
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
# Checksums file contains multiple hash types per line (CRC32, MD5, SHA1, SHA256, SHA512, etc.)
# Verify our SHA256 appears in the correct binary's line
BINARY_LINE="$(grep -E "^${YQ_BINARY}[[:space:]]" checksums)"

if [ -z "${BINARY_LINE}" ]; then
    echo "ERROR: Could not find ${YQ_BINARY} in checksums file"
    exit 1
fi

if echo "${BINARY_LINE}" | grep -q "${CHECKSUM}"; then
    echo "Checksum verified successfully (SHA256: ${CHECKSUM})"
else
    echo "ERROR: SHA256 ${CHECKSUM} not found in checksums for ${YQ_BINARY}"
    exit 1
fi

# Make it executable and move to /usr/local/bin
chmod +x yq
mv yq /usr/local/bin/yq

# Verify installation
yq --version

echo "yq ${VERSION} installed successfully"
