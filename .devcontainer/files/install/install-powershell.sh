#!/bin/sh
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
