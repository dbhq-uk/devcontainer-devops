#!/bin/bash
set -euo pipefail

# uv — fast Python package/project manager from Astral.
# https://github.com/astral-sh/uv
#
# Installed as a standalone static binary (plus `uvx`) into /usr/local/bin.
# The upstream curl|sh installer defaults to ~/.local/bin, which would land in
# the /home/vscode volume and go stale for anyone with a pre-existing one.
#
# Nothing in this image uses uv yet — it is installed for interactive use.
# Note for whoever migrates the first tool to `uv tool install`: this RUN sits
# late in the Dockerfile and will need to move above its first consumer.

WORKDIR="/tmp/install-uv"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

TARGET="x86_64-unknown-linux-gnu"

# Use provided version or fetch latest from GitHub.
# NOTE: uv's release tags have no "v" prefix (e.g. "0.11.33"), unlike most of
# the other tools installed here — do not strip one.
if [ -z "${1:-}" ]; then
    echo "Fetching latest uv version..."
    VERSION=$(curl -sI https://github.com/astral-sh/uv/releases/latest | grep -i '^location:' | sed -E 's|.*/tag/([^[:space:]]+).*|\1|')
    if [ -z "${VERSION}" ]; then
        echo "ERROR: Failed to determine latest uv version (possible rate limit)"
        exit 1
    fi
    echo "Latest version: ${VERSION}"
else
    VERSION=$1
fi

echo "Installing uv version ${VERSION}..."

TARBALL="uv-${TARGET}.tar.gz"
BASE="https://github.com/astral-sh/uv/releases/download/${VERSION}"

# Keep the upstream filename — the .sha256 file references the asset by name.
curl -sL "${BASE}/${TARBALL}" -o "${TARBALL}"
curl -sL "${BASE}/${TARBALL}.sha256" -o "${TARBALL}.sha256"
sha256sum -c "${TARBALL}.sha256"

tar -xzf "${TARBALL}"
chmod +x "uv-${TARGET}/uv" "uv-${TARGET}/uvx"
mv "uv-${TARGET}/uv" "uv-${TARGET}/uvx" /usr/local/bin/

# Cleanup
cd /
rm -rf "${WORKDIR}"

# Verify installation
uv --version
uvx --version

echo "uv ${VERSION} installed successfully (commands: uv, uvx)"