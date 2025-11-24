# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Complete devcontainer configuration for DevOps workflows
- Dockerfile with multi-tool installation
- Azure DevOps CI/CD pipeline for container registry
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
  - kubelogin (latest or pinned)
  - yq (latest or pinned)
  - jq
  - tflint (latest or pinned)
  - checkov (latest or pinned)
  - git-crypt
  - pre-commit
  - ZSH with Oh My Zsh and plugins (zsh-autosuggestions, zsh-syntax-highlighting)
- VS Code extensions for DevOps work
- ZSH as default shell with Oh My Zsh configuration
- Shell-aware environment configuration (bash/zsh completions)
- Custom .bashrc, .bash_aliases, .zshrc, and .environment files
- Entrypoint script for home directory initialization
- Persistent volume mounts for workspace and home directory
- Ansible collections: community.general, ansible.posix, azure.azcollection, community.docker, ansible.windows, community.crypto, kubernetes.core, microsoft.ad, community.windows
- Automatic installation of Python requirements for Ansible collections
- Validation and integration test scripts
- Terminal profiles for zsh, bash, and pwsh
- .gitignore and .dockerignore files
- Documentation:
  - README.md with full project documentation
  - CONTRIBUTING.md with contribution guidelines
  - SECURITY.md with security policies
  - ARCHITECTURE.md with system architecture
  - CHANGELOG.md (this file)

### Changed
- Updated all installation scripts to use dedicated /tmp/install-<tool> directories
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

### Fixed
- Entrypoint script now properly executes via postStartCommand
- Shell syntax issues in install-powershell.sh (changed from sh to bash)
- Bash completion errors in zsh by adding shell detection
- Recursive permissions for Ansible collections

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
