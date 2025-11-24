#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-terragrunt"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

OS="linux"
ARCH="amd64"
VERSION="v0.93.9"
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
 echo "Checksums match!"
else
 echo "Checksums do not match!"
fi

# Install
chmod +x "${BINARY_NAME}"
mv "${BINARY_NAME}" /usr/local/bin/terragrunt

# Verify installation
terragrunt --version

echo "Terragrunt v${VERSION} installed successfully"
