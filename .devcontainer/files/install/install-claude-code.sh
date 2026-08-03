#!/bin/bash
set -euo pipefail

echo "Installing Claude Code (native)..."

# Install Claude Code via the native installer, NOT `npm install -g`.
#
# Why: the npm-global install lands in root-owned /usr/lib/node_modules with a
# /usr/bin/claude symlink. Because the image is built as root, that tree is owned
# by root, so `claude update` / auto-updates fail with "Insufficient permissions
# to install update" for the vscode user.
#
# The native installer puts Claude under the user-owned ~/.local tree
# (~/.local/share/claude/versions/<v>, symlinked from ~/.local/bin/claude), which
# self-updates without sudo. This script must therefore run AS the target user
# (with HOME pointing at their home) and BEFORE the /tmp-home snapshot in the
# Dockerfile, so the install is seeded into the home volume on first start.
#
# Installs latest if no version is provided, otherwise the pinned version.
VERSION="${1:-latest}"

echo "Installing Claude Code version: ${VERSION}..."
curl -fsSL https://claude.ai/install.sh | bash -s -- "${VERSION}"

# Verify installation (use an explicit path; ~/.local/bin may not be on PATH yet
# in this build-time shell).
"${HOME}/.local/bin/claude" --version

echo "Claude Code installed successfully"
