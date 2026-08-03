#!/bin/bash
# Architecture detection shared by the install scripts.
#
# Source it, do not execute it:
#
#     . "$(dirname "$0")/_arch.sh"
#
# Upstream projects disagree about how to spell the same architecture, so this
# exports every spelling the install scripts actually need rather than picking
# one canonical name and making each caller translate it:
#
#   ARCH_DEB   amd64    / arm64     Debian and Go convention - most releases
#   ARCH_X64   x64      / arm64     gitleaks
#   ARCH_GNU   x86_64   / aarch64   Rust target triples - uv
#
# The leading underscore keeps it out of the install-<tool>.sh namespace; the
# Dockerfile copies and chmods the whole directory in one step, so no separate
# COPY line is needed for it.

case "$(uname -m)" in
    x86_64 | amd64)
        ARCH_DEB="amd64"
        ARCH_X64="x64"
        ARCH_GNU="x86_64"
        ;;
    aarch64 | arm64)
        ARCH_DEB="arm64"
        ARCH_X64="arm64"
        ARCH_GNU="aarch64"
        ;;
    *)
        echo "ERROR: unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

export ARCH_DEB ARCH_X64 ARCH_GNU
