#!/bin/bash
set -euo pipefail

echo "Installing Terraform..."

# Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

# Add HashiCorp apt repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update

# Install specific version if provided, otherwise install latest
if [ -n "${1:-}" ]; then
    echo "Installing Terraform version ${1}..."
    sudo apt-get install -y terraform="${1}-*"
else
    echo "Installing latest Terraform..."
    sudo apt-get install -y terraform
fi

# Verify installation
terraform version

echo "Terraform installed successfully"
