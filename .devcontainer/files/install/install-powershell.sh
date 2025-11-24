#!/bin/bash
set -e

WORKDIR="/tmp/install-powershell"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Install PowerShell on Ubuntu

# Update package list
apt-get update

# Install dependencies
apt-get install -y wget apt-transport-https software-properties-common

# Get Ubuntu version
. /etc/os-release

# Download the Microsoft repository keys
wget -q "https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb"

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
MODULES="Az Pester PSScriptAnalyzer powershell-yaml ImportExcel"

for MODULE in ${MODULES}; do
    echo "Installing module: ${MODULE}"
    pwsh -NoProfile -NonInteractive -Command "if (-not (Get-Module -ListAvailable -Name '${MODULE}')) { Install-Module -Name '${MODULE}' -Scope AllUsers -Repository PSGallery -Force -AllowClobber }"
done

echo "PowerShell modules installed successfully"
