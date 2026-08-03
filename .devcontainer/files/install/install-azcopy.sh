#!/bin/bash
set -euo pipefail

. "$(dirname "$0")/_arch.sh"

WORKDIR="/tmp/install-azcopy"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# aka.ms serves the current release per architecture; the amd64 alias has no
# suffix, arm64 does.
if [ "${ARCH_DEB}" = "amd64" ]; then
    LATEST_URL="https://aka.ms/downloadazcopy-v10-linux"
else
    LATEST_URL="https://aka.ms/downloadazcopy-v10-linux-${ARCH_DEB}"
fi

# Get latest version if not specified
if [ -z "${1:-}" ]; then
    echo "Installing latest azcopy..."
    DOWNLOAD_URL="${LATEST_URL}"
else
    VERSION=$1
    echo "Installing azcopy version ${VERSION}..."
    DOWNLOAD_URL="https://azcopyvnext.azureedge.net/releases/release-${VERSION}-20*/azcopy_linux_${ARCH_DEB}_${VERSION}.tar.gz"
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
