#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-tf-summarize"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

OS="linux"
ARCH="amd64"

# Use provided version or fetch latest from GitHub
if [ -z "${1:-}" ]; then
    echo "Fetching latest tf-summarize version..."
    VERSION=$(curl -sI https://github.com/dineshba/tf-summarize/releases/latest | grep -i '^location:' | sed -E 's|.*/v([^[:space:]]+).*|\1|')
    if [ -z "${VERSION}" ]; then
        echo "ERROR: Failed to determine latest tf-summarize version"
        exit 1
    fi
    echo "Latest version: ${VERSION}"
else
    VERSION=$1
fi

echo "Installing tf-summarize version ${VERSION}..."

# Download the tarball
TARBALL="tf-summarize_${OS}_${ARCH}.tar.gz"
curl -sL "https://github.com/dineshba/tf-summarize/releases/download/v${VERSION}/${TARBALL}" -o "${TARBALL}"

# Extract and install
tar -xzf "${TARBALL}"
chmod +x tf-summarize
mv tf-summarize /usr/local/bin/

# Cleanup
cd /
rm -rf "${WORKDIR}"

# Verify installation
tf-summarize -v

echo "tf-summarize ${VERSION} installed successfully"
