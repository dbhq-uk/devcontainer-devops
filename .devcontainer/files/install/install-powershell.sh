#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-powershell"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Install PowerShell on Ubuntu

# Get Ubuntu version dynamically
. /etc/os-release

# Download the Microsoft repository keys using detected version
wget -q "https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/packages-microsoft-prod.deb"

# Register the Microsoft repository keys
dpkg -i packages-microsoft-prod.deb

# Update package list
apt-get update

# Install PowerShell
apt-get install -y --no-install-recommends powershell
rm -rf /var/lib/apt/lists/*

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
