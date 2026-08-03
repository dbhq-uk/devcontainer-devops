#!/bin/bash
set -euo pipefail

. "$(dirname "$0")/_arch.sh"

WORKDIR="/tmp/install-gitleaks"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Get latest version if not specified
if [ -z "${1:-}" ]; then
    echo "Fetching latest gitleaks version..."
    VERSION=$(curl -sI https://github.com/gitleaks/gitleaks/releases/latest | grep -i '^location:' | sed -E 's|.*/v([^[:space:]]+).*|\1|')
    if [ -z "${VERSION}" ]; then
        echo "ERROR: Failed to determine latest gitleaks version (possible rate limit)"
        exit 1
    fi
    echo "Latest version: ${VERSION}"
else
    VERSION=$1
fi

echo "Installing gitleaks version ${VERSION}..."

curl -L "https://github.com/gitleaks/gitleaks/releases/download/v${VERSION}/gitleaks_${VERSION}_linux_${ARCH_X64}.tar.gz" -o gitleaks.tar.gz

tar -xzf gitleaks.tar.gz gitleaks
chmod +x gitleaks
mv gitleaks /usr/local/bin/

gitleaks version

echo "gitleaks ${VERSION} installed successfully"
