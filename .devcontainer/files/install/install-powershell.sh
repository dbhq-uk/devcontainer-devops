#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-powershell"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Install PowerShell on Ubuntu

# Update package list
apt-get update

# Install dependencies
apt-get install -y wget apt-transport-https software-properties-common

# Get Ubuntu version dynamically
. /etc/os-release

# Download the Microsoft repository keys using detected version
wget -q "https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/packages-microsoft-prod.deb"

# Register the Microsoft repository keys
dpkg -i packages-microsoft-prod.deb

# Update package list
apt-get update

# Install PowerShell
apt-get install -y powershell

# Configure PSGallery as trusted repository
echo "Configuring PSGallery..."
pwsh -NoProfile -NonInteractive -Command "Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'"

# Install common PowerShell modules
echo "Installing PowerShell modules..."
MODULES="Az Pester PSScriptAnalyzer powershell-yaml ImportExcel posh-git z PSFzf Terminal-Icons"

for MODULE in ${MODULES}; do
    echo "Installing module: ${MODULE}"
    pwsh -NoProfile -NonInteractive -Command "if (-not (Get-Module -ListAvailable -Name '${MODULE}')) { Install-Module -Name '${MODULE}' -Scope AllUsers -Repository PSGallery -Force -AllowClobber }"
done

# Install oh-my-posh (download then execute, not piped)
curl -sSLo /tmp/install-ohmyposh.sh https://ohmyposh.dev/install.sh
bash /tmp/install-ohmyposh.sh
rm -f /tmp/install-ohmyposh.sh

echo "PowerShell modules installed successfully"
