#!/bin/bash
set -e

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

# Install common Python packages
python3 -m pip install \
    requests \
    jmespath \
    resolvelib

# Validation
python3 --version
pip3 --version

echo "Python tools installed successfully"
