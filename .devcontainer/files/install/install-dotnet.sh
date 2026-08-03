#!/bin/bash
set -euo pipefail

echo "Installing .NET SDK..."

WORKDIR="/tmp/install-dotnet"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# .NET 10 is the current LTS (GA November 2025). We install via Microsoft's
# official dotnet-install.sh rather than the packages.microsoft.com apt feed:
# it pins the 10.0 channel cleanly and avoids the known conflicts between that
# feed and Ubuntu 24.04's own dotnet packages. Matches the repo's vendor-script
# pattern (claude-code, oh-my-posh).
DOTNET_INSTALL_DIR="/usr/share/dotnet"

# The .NET runtime needs ICU for globalization. dotnet-install.sh only drops
# binaries and installs no OS dependencies, so ensure ICU is present.
# libicu-dev is version-agnostic (pulls the distro's current libicuNN), so this
# keeps working across Ubuntu base bumps.
apt-get update
apt-get install -y --no-install-recommends libicu-dev
rm -rf /var/lib/apt/lists/*

# An explicit SDK version pins exactly; otherwise take the latest SDK on the
# 10.0 LTS channel.
if [ -n "${1:-}" ]; then
    echo "Installing .NET SDK version ${1}..."
    INSTALL_ARGS=(--version "${1}")
else
    echo "Installing latest .NET SDK on the 10.0 LTS channel..."
    INSTALL_ARGS=(--channel 10.0)
fi

curl -fsSL https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh "${INSTALL_ARGS[@]}" --install-dir "${DOTNET_INSTALL_DIR}"

# Expose the CLI on PATH for all users (DOTNET_ROOT is also set in the Dockerfile).
ln -sf "${DOTNET_INSTALL_DIR}/dotnet" /usr/local/bin/dotnet

# cd out of WORKDIR before deleting it: dotnet calls getcwd() while building its
# command tree and throws (TypeInitializationException -> FileNotFoundException)
# if the current working directory has been removed.
cd /
rm -rf "${WORKDIR}"

# Verify installation. Set DOTNET_ROOT explicitly in case this runs before the
# Dockerfile ENV takes effect.
export DOTNET_ROOT="${DOTNET_INSTALL_DIR}"
dotnet --info

echo ".NET SDK installed successfully"
