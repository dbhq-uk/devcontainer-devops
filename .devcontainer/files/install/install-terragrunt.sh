#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-terragrunt"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

OS="linux"
ARCH="amd64"

# Use provided version or fetch latest from GitHub
if [ -z "${1:-}" ]; then
    echo "Fetching latest Terragrunt version..."
    VERSION=$(curl -sI https://github.com/gruntwork-io/terragrunt/releases/latest | grep -i '^location:' | sed -E 's|.*(v[^[:space:]]+).*|\1|')
    if [ -z "${VERSION}" ]; then
        echo "ERROR: Failed to determine latest Terragrunt version"
        exit 1
    fi
    echo "Latest version: ${VERSION}"
else
    VERSION="v${1}"
fi

BINARY_NAME="terragrunt_${OS}_${ARCH}"

# Download the binary
curl -sL "https://github.com/gruntwork-io/terragrunt/releases/download/$VERSION/$BINARY_NAME" -o "${BINARY_NAME}"

# Generate the checksum
CHECKSUM="$(sha256sum "${BINARY_NAME}" | awk '{print $1}')"

# Download the checksum file
curl -sL "https://github.com/gruntwork-io/terragrunt/releases/download/$VERSION/SHA256SUMS" -o "SHA256SUMS"

# Grab the expected checksum (exact match on filename)
EXPECTED_CHECKSUM="$(awk -v binary="$BINARY_NAME" '$2 == binary {print $1; exit}' SHA256SUMS)"

# Compare the checksums
if [ "$CHECKSUM" == "$EXPECTED_CHECKSUM" ]; then
    echo "Checksum verified successfully"
else
    echo "ERROR: Checksum mismatch! Expected: ${EXPECTED_CHECKSUM}, Got: ${CHECKSUM}"
    exit 1
fi

# Install
chmod +x "${BINARY_NAME}"
mv "${BINARY_NAME}" /usr/local/bin/terragrunt

# Verify installation
terragrunt --version

echo "Terragrunt v${VERSION} installed successfully"
