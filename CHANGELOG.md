# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Releases are calendar-versioned (`vYYYY.MM.DD`) rather than semantically
versioned. Most tools install at "latest", so a tag records what the image
contained on a given date; it cannot promise a compatibility contract.

## [Unreleased]

### Added

- Multi-root workspace support: a `ws` command that clones repositories into the
  persistent `/workspace` volume and manages the roots of
  `/workspace/devops.code-workspace`, so several repositories open in one
  container. Created automatically by `postCreateCommand`
- Complete devcontainer configuration for DevOps workflows
- Dockerfile with multi-tool installation
- Installation scripts with isolated /tmp directories for:
  - Terraform (latest or pinned version)
  - Terragrunt (v0.93.9)
  - Azure CLI (latest)
  - Docker Engine
  - Kubernetes kubectl (latest or pinned)
  - Helm (latest or pinned)
  - Ansible with collections and Python dependencies
  - PowerShell with modules (Az, Pester, PSScriptAnalyzer, powershell-yaml, ImportExcel)
  - Python 3 with DevOps packages
  - .NET SDK 10 (LTS channel 10.0, or a pinned SDK version)
  - kubelogin (latest or pinned)
  - yq (latest or pinned)
  - jq
  - tflint (latest or pinned)
  - checkov (latest or pinned)
  - git-crypt
  - pre-commit
  - ZSH with Oh My Zsh and plugins (zsh-autosuggestions, zsh-syntax-highlighting)
- VS Code extensions for DevOps work (including C# and C# Dev Kit for .NET development)
- ZSH as default shell with Oh My Zsh configuration
- Shell-aware environment configuration (bash/zsh completions)
- Custom .bashrc, .bash_aliases, .zshrc, and .environment files
- Entrypoint script for home directory initialization
- Persistent volume mounts for workspace and home directory
- Ansible collections: community.general, ansible.posix, azure.azcollection, community.docker, ansible.windows, community.crypto, kubernetes.core, microsoft.ad, community.windows
- Automatic installation of Python requirements for Ansible collections
- claude-swap (`cswap`), the Claude Code multi-account switcher, installed
  system-wide from PyPI (latest or pinned via `CSWAP_VERSION`)
- uv (`uv`, `uvx`), the Astral Python package/project manager, installed as a
  standalone binary with SHA256 verification (latest or pinned via `UV_VERSION`).
  Available for interactive use only — no tool is installed through it yet
- Validation and integration test scripts
- Terminal profiles for zsh, bash, and pwsh
- .gitignore and .dockerignore files
- Documentation:
  - README.md with full project documentation
  - CONTRIBUTING.md with contribution guidelines
  - SECURITY.md with security policies
  - ARCHITECTURE.md with system architecture
  - CHANGELOG.md (this file)
- GitHub Actions CI publishing to the GitHub Container Registry:
  - `ci.yml` lints, builds and tests both architectures on pull requests, and
    publishes `:main` / `:sha-<short>` on pushes to `main`
  - `release.yml` cuts a weekly calendar-versioned release from a `--no-cache`
    rebuild and moves `:latest`
  - `build.yml` holds the shared build so the two entry points cannot drift
  - SBOM and Sigstore-signed SLSA build provenance on every published image
  - Trivy scanning reported to the Security tab, non-blocking by design
- `linux/arm64` images alongside `linux/amd64`, each built on a native runner
- `_arch.sh`, a sourced helper giving the install scripts the architecture in
  the three spellings upstreams use
- `.hadolint.yaml`, so Dockerfile lint rules are shared by CI and pre-commit
- `.gitattributes`, declaring LF for every text file
- `.markdownlint.json` and `.yamllint.yaml`, so the markdown and YAML hooks
  have rules that match this repository rather than failing on their defaults
- `.secrets.baseline`, without which the `detect-secrets` hook could not run

### Changed

- Updated all installation scripts to use dedicated `/tmp/install-<tool>` directories
- Set zsh as default shell for vscode user
- Configured postStartCommand to run entrypoint script
- Environment file now detects shell type and loads appropriate completions
- Optimized Docker layers for better caching
- Fixed Ubuntu version from 22.01 to 22.04
- Enhanced bash aliases for all major tools
- Improved terminal configuration with shell-specific completions
- PowerShell installer now configures PSGallery and installs common modules
- Ansible installer automatically finds and installs collection requirements
- Added cleanup step to remove /tmp/install-* directories
- Bumped default Node.js major from 22 to 24 LTS
- CA trust is now a bring-your-own drop-in: put a PEM `*.crt` chain in
  `.devcontainer/files/certs/` and the Dockerfile merges it into the system
  bundle. `NODE_EXTRA_CA_CERTS` points at `/etc/ssl/certs/ca-certificates.crt`
  rather than a single named certificate, so the build works with no
  certificates supplied
- `devcontainer.json` pulls the published image by default; the local
  Dockerfile build is now the commented-out contributor path
- PowerShell installs from the upstream tarball on `arm64` - Microsoft's Ubuntu
  package repository publishes the `powershell` deb for `amd64` only
- Helm's checksum verification is now actually performed; it was downloaded and
  then verified by a commented-out line
- The `shellcheck` and `hadolint` pre-commit hooks now read the same config
  as the CI lint job, so a clean run locally means a clean run in CI

### Removed

- `azure-pipelines.yml` and its Azure Container Registry and Dependency-Track
  integration, replaced by the GitHub Actions workflows above
- The `ansible-lint` pre-commit hook and `.ansible-lint`. This repo contains no
  playbooks or roles, and the hook was pointed at the GitHub workflow files

### Fixed

- Entrypoint script now properly executes via postStartCommand
- Shell syntax issues in install-powershell.sh (changed from sh to bash)
- Bash completion errors in zsh by adding shell detection
- Recursive permissions for Ansible collections
- `pre-commit run --all-files` now completes. It previously failed on a missing
  `.secrets.baseline`, on `check-json` parsing the JSONC `devcontainer.json`,
  on 21 scripts carrying a shebang without an executable bit, and on an
  `ansible-lint` hook incompatible with current `ansible-core`
- `install-azcopy.sh` can now install a pinned version. The URL pointed at a
  retired CDN via a path containing a shell glob that curl cannot expand, so
  that branch could never have worked; it now uses the GitHub release asset
- Line endings are consistent. The repo mixed CRLF docs with LF scripts and
  declared neither, so editing a file could silently leave it mixed

### Security

- Added checksum validation for downloaded binaries (kubectl, helm, yq, terragrunt)
- Pinned tool versions for reproducibility where appropriate
- Added security scanning tools (checkov, tflint)
- Implemented git-crypt for secret management

## [1.0.0] - 2025-11-21

### Added

- Initial release of DevOps DevContainer
- Basic tool installations
- Simple devcontainer configuration

---

## Version History

### How to Update This File

When making changes:

1. Add entries under `[Unreleased]` section
2. Organize by type: Added, Changed, Deprecated, Removed, Fixed, Security
3. When releasing, rename `[Unreleased]` to version number with date
4. Create new `[Unreleased]` section

### Version Numbering

- **MAJOR**: Incompatible changes (breaking changes)
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

Example: 2.1.3

- 2 = Major version
- 1 = Minor version
- 3 = Patch version
