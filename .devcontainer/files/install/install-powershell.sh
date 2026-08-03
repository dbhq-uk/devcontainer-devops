#!/bin/bash
set -euo pipefail

. "$(dirname "$0")/_arch.sh"

WORKDIR="/tmp/install-powershell"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Install PowerShell on Ubuntu.
#
# Microsoft's Ubuntu package repo publishes the `powershell` deb for amd64
# only - there is no arm64 build in packages.microsoft.com/ubuntu/<ver>/prod -
# so arm64 installs from the upstream linux-arm64 tarball instead. Everything
# below the install (PSGallery, modules, oh-my-posh) is common to both.

# Get Ubuntu version dynamically
. /etc/os-release

if [ "${ARCH_DEB}" = "amd64" ]; then
    # Download the Microsoft repository keys using detected version
    wget -q "https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/packages-microsoft-prod.deb"

    # Register the Microsoft repository keys
    dpkg -i packages-microsoft-prod.deb

    # Update package list
    apt-get update

    # Install PowerShell
    # NOTE: the apt path tracks whatever the repo currently serves and ignores
    # $1 - only the tarball path below honours a pinned POWERSHELL_VERSION.
    apt-get install -y --no-install-recommends powershell
    rm -rf /var/lib/apt/lists/*
else
    # Resolve the version - the tarball URL has no "latest" alias.
    if [ -z "${1:-}" ]; then
        echo "Fetching latest PowerShell version..."
        VERSION=$(curl -sI https://github.com/PowerShell/PowerShell/releases/latest | grep -i '^location:' | sed -E 's|.*/v([^[:space:]]+).*|\1|')
        if [ -z "${VERSION}" ]; then
            echo "ERROR: Failed to determine latest PowerShell version"
            exit 1
        fi
        echo "Latest version: ${VERSION}"
    else
        VERSION=$1
    fi

    # The deb would have pulled these in. Resolve the names rather than hardcode
    # them - Ubuntu suffixes several across releases (libssl3 -> libssl3t64,
    # liblttng-ust1 -> liblttng-ust1t64 on noble).
    apt-get update
    PS_DEPS=""
    for pat in 'libicu[0-9]+' 'liblttng-ust[0-9a-z]*' 'libssl3[a-z0-9]*' 'libgssapi-krb5-2'; do
        pkg="$(apt-cache search --names-only "^${pat}\$" | awk '{print $1}' | sort -V | tail -1)"
        if [ -n "${pkg}" ]; then
            PS_DEPS="${PS_DEPS} ${pkg}"
        fi
    done
    echo "PowerShell runtime dependencies:${PS_DEPS}"
    # shellcheck disable=SC2086
    apt-get install -y --no-install-recommends ${PS_DEPS}
    rm -rf /var/lib/apt/lists/*

    echo "Installing PowerShell ${VERSION} from the linux-${ARCH_DEB} tarball..."
    TARBALL="powershell-${VERSION}-linux-${ARCH_DEB}.tar.gz"
    curl -sSL "https://github.com/PowerShell/PowerShell/releases/download/v${VERSION}/${TARBALL}" -o "${TARBALL}"

    # Same layout the deb uses, so profiles and module paths line up.
    install -d /opt/microsoft/powershell/7
    tar -xzf "${TARBALL}" -C /opt/microsoft/powershell/7
    chmod +x /opt/microsoft/powershell/7/pwsh
    ln -sf /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
fi

# Fails the build loudly if a runtime dependency is missing
pwsh --version

# Configure PSGallery as trusted repository
echo "Configuring PSGallery..."
pwsh -NoProfile -NonInteractive -Command "Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'"

# Install common PowerShell modules in a single pwsh invocation
echo "Installing PowerShell modules..."
pwsh -NoProfile -NonInteractive -Command "
    \$modules = @('Az','Pester','PSScriptAnalyzer','powershell-yaml','ImportExcel','posh-git','z','PSFzf','Terminal-Icons')
    foreach (\$m in \$modules) {
        Write-Host \"Installing module: \$m\"
        Install-Module -Name \$m -Scope AllUsers -Repository PSGallery -Force -AllowClobber
    }
"

# Install oh-my-posh to a system-wide location so the vscode user can find it
curl -sSLo /tmp/install-ohmyposh.sh https://ohmyposh.dev/install.sh
bash /tmp/install-ohmyposh.sh -d /usr/local/bin
rm -f /tmp/install-ohmyposh.sh

echo "PowerShell modules installed successfully"
