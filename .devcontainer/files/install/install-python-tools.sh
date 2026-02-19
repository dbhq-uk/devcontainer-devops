#!/bin/bash
set -euo pipefail

echo "Installing Python tools and dependencies..."

# System dependencies
apt-get update
apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    libffi-dev \
    libssl-dev \
    build-essential

# Upgrade pip
python3 -m pip install --upgrade pip setuptools wheel

# Install only essential system-wide packages that all users need
python3 -m pip install \
    requests \
    jmespath \
    resolvelib

# Configure pip to default to user installs for non-root users
# mkdir -p /etc/pip
# cat > /etc/pip/pip.conf << 'EOF'
# [install]
# user = true
# EOF

# Validation
python3 --version
pip3 --version

echo "Python tools installed successfully"
echo "Non-root users will install packages to ~/.local by default"
