#!/bin/bash
set -euo pipefail

. "$(dirname "$0")/_arch.sh"

WORKDIR="/tmp/install-azcopy"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

if [ -z "${1:-}" ]; then
    # aka.ms serves the current release per architecture. The amd64 alias has
    # no suffix, arm64 does. Both redirect to the GitHub release asset.
    echo "Installing latest azcopy..."
    if [ "${ARCH_DEB}" = "amd64" ]; then
        DOWNLOAD_URL="https://aka.ms/downloadazcopy-v10-linux"
    else
        DOWNLOAD_URL="https://aka.ms/downloadazcopy-v10-linux-${ARCH_DEB}"
    fi
else
    # Pinned version: go straight to the GitHub release, which is where the
    # aka.ms aliases end up anyway.
    #
    # The previous URL here could never have worked - it pointed at
    # azcopyvnext.azureedge.net, a retired CDN, via a path containing a shell
    # glob ("release-${VERSION}-20*") that curl has no way to expand. Nothing
    # noticed because versions.json leaves azcopy empty, so only the branch
    # above is ever taken.
    VERSION=$1
    echo "Installing azcopy version ${VERSION}..."
    DOWNLOAD_URL="https://github.com/Azure/azure-storage-azcopy/releases/download/v${VERSION}/azcopy_linux_${ARCH_DEB}_${VERSION}.tar.gz"
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
