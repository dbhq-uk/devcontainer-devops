#!/bin/sh
set -e

WORKDIR="/tmp/install-azure-cli"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

curl -sSLo install-az.sh https://aka.ms/InstallAzureCLIDeb 
bash install-az.sh