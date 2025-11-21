#!/bin/bash
set -e

echo "Installing Terragrunt..."

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        TG_ARCH="amd64"
        ;;
    aarch64|arm64)
        TG_ARCH="arm64"
        ;;
    armv7l)
        TG_ARCH="arm"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Get latest version from GitHub API
TG_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

if [ -z "$TG_VERSION" ]; then
    echo "Failed to fetch latest terragrunt version"
    exit 1
fi

echo "Latest Terragrunt version: $TG_VERSION"

# Download and install terragrunt
TG_BINARY="terragrunt_linux_${TG_ARCH}"
DOWNLOAD_URL="https://github.com/gruntwork-io/terragrunt/releases/download/v${TG_VERSION}/${TG_BINARY}"

echo "Downloading from: $DOWNLOAD_URL"
curl -L "$DOWNLOAD_URL" -o /tmp/terragrunt

# Make it executable and move to /usr/local/bin
chmod +x /tmp/terragrunt
sudo mv /tmp/terragrunt /usr/local/bin/terragrunt

# Verify installation
if command -v terragrunt &> /dev/null; then
    echo "Terragrunt successfully installed!"
    terragrunt --version
else
    echo "Terragrunt installation failed"
    exit 1
fi
