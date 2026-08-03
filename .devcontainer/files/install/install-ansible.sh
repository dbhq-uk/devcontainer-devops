#!/bin/bash
set -euo pipefail

WORKDIR="/tmp/install-ansible"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Kerberos build dep: the windows/kerberos-backed collections pull in the `krb5`
# Python package, which has no wheel here and builds from sdist needing
# krb5-config (provided by libkrb5-dev). build-essential/python3-dev already
# come from the earlier install-python-tools.sh layer.
apt-get update
apt-get install -y --no-install-recommends libkrb5-dev
rm -rf /var/lib/apt/lists/*

# Install Ansible via pip (PPA is unreliable on Ubuntu 24.04+)
echo "Installing Ansible via pip..."

python3 -m pip install --no-cache-dir ansible

echo "Ansible installed successfully"

# Install Ansible collections
echo "Installing Ansible collections..."
COLLECTIONS_PATH="/usr/share/ansible/collections"

# The collections we actually use. Kept in one array so the galaxy install and
# the dependency install below stay in sync.
COLLECTIONS=(
    community.general
    ansible.posix
    azure.azcollection
    community.docker
    ansible.windows
    community.crypto
    kubernetes.core
    microsoft.ad
    community.windows
)

ansible-galaxy collection install -p "${COLLECTIONS_PATH}" "${COLLECTIONS[@]}"

# Install Python dependencies for ONLY the collections above.
#
# `pip install ansible` bundles ~90 collections under site-packages, so when
# `ansible-galaxy -p` finds those already satisfy the request it installs
# nothing new under COLLECTIONS_PATH. We therefore resolve each wanted
# collection's requirements.txt explicitly instead of `find`-ing *every*
# requirements.txt - the latter dragged in unrelated collections (ovirt,
# netapp, ...) and their exotic C build deps. Without this step the
# azure_rm dynamic inventory breaks with "No module named 'azure'".
#
# A collection may live under COLLECTIONS_PATH (galaxy) or the bundled
# site-packages copy. ansible_collections is a PEP-420 namespace package, so
# its __file__ is None; read __path__ for the bundled root(s).
echo "Installing Python dependencies for Ansible collections..."
mapfile -t SITE_ROOTS < <(python3 -c '
import ansible_collections
for p in getattr(ansible_collections, "__path__", []) or []:
    print(p)
' 2>/dev/null || true)
roots=("${COLLECTIONS_PATH}/ansible_collections" "${SITE_ROOTS[@]:-}")

azure_done=0
for coll in "${COLLECTIONS[@]}"; do
    ns="${coll%%.*}"; name="${coll#*.}"
    for root in "${roots[@]}"; do
        [ -n "${root}" ] || continue
        req="${root}/${ns}/${name}/requirements.txt"
        if [ -f "${req}" ]; then
            echo "  -> ${coll}: ${req}"
            # --ignore-installed: azure.azcollection pins a newer cryptography
            # than the apt-managed python3-cryptography, which pip cannot
            # uninstall (no RECORD file) on Ubuntu 24.04+. Overlay into
            # /usr/local instead. Matches install-python-tools.sh.
            python3 -m pip install --no-cache-dir --ignore-installed -r "${req}"
            [ "${coll}" = "azure.azcollection" ] && azure_done=1
            break
        fi
    done
done

# Guard the original regression: the azure_rm inventory needs the azure SDK.
if [ "${azure_done}" -ne 1 ]; then
    echo "ERROR: azure.azcollection requirements.txt not found; azure_rm inventory would break" >&2
    exit 1
fi
python3 -c "import azure.identity, azure.mgmt.resource" \
    || { echo "ERROR: azure SDK not importable after install (azure_rm would break)" >&2; exit 1; }

# Install passlib for Ansible password hashing (user module)
python3 -m pip install --no-cache-dir passlib

# Security: enforce minimum safe versions to remediate SBOM vulnerabilities introduced
# transitively by azure.azcollection and other collection requirements.
echo "Enforcing minimum safe Python package versions..."
python3 -m pip install --no-cache-dir \
    "aiohttp>=3.14.1" \
    "cryptography>=48.0.1" \
    "PyJWT>=2.13.0" \
    "paramiko>=5.0.0" \
    "knack>=0.14.0"

# Set proper permissions for all users to read ansible collections
chmod -R a+rX ${COLLECTIONS_PATH}

echo "Ansible collections installed successfully"
