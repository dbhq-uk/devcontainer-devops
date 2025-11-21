#!/bin/bash
set -e

echo "Installing yq..."

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        YQ_ARCH="amd64"
        ;;
    aarch64|arm64)
        YQ_ARCH="arm64"
        ;;
    armv7l)
        YQ_ARCH="arm"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Get latest version from GitHub API
YQ_VERSION=$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

if [ -z "$YQ_VERSION" ]; then
    echo "Failed to fetch latest yq version"
    exit 1
fi

echo "Latest yq version: $YQ_VERSION"

# Download and install yq
YQ_BINARY="yq_linux_${YQ_ARCH}"
DOWNLOAD_URL="https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/${YQ_BINARY}"

echo "Downloading from: $DOWNLOAD_URL"
curl -L "$DOWNLOAD_URL" -o /tmp/yq

# Make it executable and move to /usr/local/bin
chmod +x /tmp/yq
sudo mv /tmp/yq /usr/local/bin/yq

# Verify installation
if command -v yq &> /dev/null; then
    echo "yq successfully installed!"
    yq --version
else
    echo "yq installation failed"
    exit 1
fi
