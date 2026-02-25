#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-azcopy"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Get latest version if not specified
if [ -z "${1:-}" ]; then
    echo "Installing latest azcopy..."
    DOWNLOAD_URL="https://aka.ms/downloadazcopy-v10-linux"
else
    VERSION=$1
    echo "Installing azcopy version ${VERSION}..."
    DOWNLOAD_URL="https://azcopyvnext.azureedge.net/releases/release-${VERSION}-20*/azcopy_linux_amd64_${VERSION}.tar.gz"
fi

# Download and extract
curl -sSL "${DOWNLOAD_URL}" -o azcopy.tar.gz
tar xzf azcopy.tar.gz --strip-components=1

# Install
chmod +x azcopy
mv azcopy /usr/local/bin/

# Verify installation
azcopy --version

echo "azcopy installed successfully"
