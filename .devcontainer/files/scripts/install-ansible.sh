#!/bin/sh
# Install Ansible on Ubuntu

# Update package list
apt-get update

# Install dependencies
apt-get install -y software-properties-common

# Add Ansible PPA
add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
apt-get install -y ansible
