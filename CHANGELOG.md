# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Complete devcontainer configuration for DevOps workflows
- Dockerfile with multi-tool installation
- Azure DevOps CI/CD pipeline for container registry
- Installation scripts for:
  - Terraform 1.13.5
  - Terragrunt 0.70.4
  - Azure CLI 2.79.0
  - Docker Engine
  - Kubernetes kubectl 1.34.2
  - Helm 4.0.0
  - Ansible 2.18.1
  - PowerShell 7.5.4
  - Python 3 with DevOps packages
  - kubelogin 0.1.9
  - yq 4.44.6
  - jq 1.7.1
  - tflint 0.54.0
  - checkov 3.2.337
  - git-crypt
- VS Code extensions for DevOps work
- Custom bash configuration with comprehensive aliases
- Optional ZSH support with Oh My Zsh
- Environment variable configuration
- Validation and integration test scripts
- .gitignore and .dockerignore files
- Documentation:
  - README.md with full project documentation
  - CONTRIBUTING.md with contribution guidelines
  - SECURITY.md with security policies
  - CHANGELOG.md (this file)

### Changed
- Updated Dockerfile to use versioned installations with checksum validation
- Optimized Docker layers for better caching
- Fixed Ubuntu version from 22.01 to 22.04
- Enhanced bash aliases for all major tools
- Improved terminal configuration with completions

### Security
- Added checksum validation for all downloaded binaries
- Pinned all tool versions for reproducibility
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
