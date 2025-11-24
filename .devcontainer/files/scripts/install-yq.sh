#!/bin/bash
set -e

# Get latest version if not specified
if [ -z "$1" ]; then
    echo "Fetching latest yq version..."
    VERSION=$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    echo "Latest version: ${VERSION}"
else
    VERSION=$1
fi

echo "Installing yq version ${VERSION}..."


# Download yq
YQ_BINARY="yq_linux_AMD64"
DOWNLOAD_URL="https://github.com/mikefarah/yq/releases/download/v${VERSION}/${YQ_BINARY}"

echo "Downloading from: $DOWNLOAD_URL"
curl -L "$DOWNLOAD_URL" -o /tmp/yq

# Download checksum
curl -L "https://github.com/mikefarah/yq/releases/download/v${VERSION}/checksums" -o /tmp/checksums

# # Verify checksum
# cd /tmp
# grep "yq_linux_${YQ_ARCH}" checksums | sha256sum -c

# Make it executable and move to /usr/local/bin
chmod +x /tmp/yq
mv /tmp/yq /usr/local/bin/yq

# Cleanup
rm /tmp/checksums

# Verify installation
yq --version

echo "yq ${VERSION} installed successfully"
