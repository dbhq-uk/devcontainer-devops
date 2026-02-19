#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-ansible"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Install Ansible via pip (PPA is unreliable on Ubuntu 24.04+)
echo "Installing Ansible via pip..."

python3 -m pip install --no-cache-dir ansible

echo "Ansible installed successfully"

# Install Ansible collections
echo "Installing Ansible collections..."
COLLECTIONS_PATH="/usr/share/ansible/collections"

ansible-galaxy collection install -p ${COLLECTIONS_PATH} \
    community.general \
    ansible.posix \
    azure.azcollection \
    community.docker \
    ansible.windows \
    community.crypto \
    kubernetes.core \
    microsoft.ad \
    community.windows

# Install Python dependencies from collection requirements
echo "Installing Python dependencies for Ansible collections..."
find ${COLLECTIONS_PATH} -name requirements.txt -exec python3 -m pip install --no-cache-dir -r {} \;

# Set proper permissions for all users to read ansible collections
chmod -R a+rX ${COLLECTIONS_PATH}

echo "Ansible collections installed successfully"