# Pre-commit Hooks

This repository uses [pre-commit](https://pre-commit.com/) to automatically run checks before commits.

## Installation

Pre-commit is already installed in the devcontainer. To enable the hooks:

```bash
pre-commit install
pre-commit install --hook-type commit-msg
```

## What Gets Checked

### General
- Trailing whitespace
- End of file fixes
- Large files detection
- Merge conflict markers
- Private key detection

### Shell Scripts
- ShellCheck linting
- Shebang validation
- Execute permissions

### Terraform
- Format checking (`terraform fmt`)
- Validation (`terraform validate`)
- Documentation generation
- Security scanning (checkov)
- Linting (tflint)

### Ansible
- Ansible-lint for playbooks
- YAML syntax validation

### Python
- Code formatting (black)
- Style checking (flake8)
- Import sorting

### Docker
- Dockerfile linting (hadolint)

### Documentation
- Markdown linting
- YAML linting

### Security
- Secret detection
- Private key scanning

### Git
- Conventional commit message format

## Usage

### Automatic (Recommended)

After installation, hooks run automatically on `git commit`:

```bash
git add .
git commit -m "feat: add new feature"
# Pre-commit hooks run automatically
```

### Manual Run

Run checks on all files:
```bash
pre-commit run --all-files
```

Run specific hook:
```bash
pre-commit run terraform-fmt --all-files
pre-commit run shellcheck --all-files
```

### Update Hooks

Update to latest versions:
```bash
pre-commit autoupdate
```

## Bypassing Hooks

**Not recommended**, but if needed:
```bash
git commit --no-verify -m "emergency fix"
```

## Configuration

Hooks are configured in `.pre-commit-config.yaml`. To modify:

1. Edit `.pre-commit-config.yaml`
2. Update hook versions or add new hooks
3. Run `pre-commit install` again
4. Test with `pre-commit run --all-files`

## Troubleshooting

### Hook fails to run

```bash
# Reinstall hooks
pre-commit uninstall
pre-commit install
```

### Clean hook cache

```bash
pre-commit clean
pre-commit run --all-files
```

### Skip specific files

Add to `.pre-commit-config.yaml`:
```yaml
exclude: |
  (?x)^(
      path/to/exclude/|
      specific-file.txt
  )
```

## CI/CD Integration

Pre-commit also runs in the Azure DevOps pipeline to ensure consistency.

## Common Issues

### Terraform validation fails

Ensure Terraform is initialized:
```bash
cd terraform/
terraform init
```

### Ansible-lint fails

Check `.ansible-lint` configuration or update playbook syntax.

### Hadolint fails

Fix Dockerfile issues or add ignore rules:
```yaml
args: ['--ignore', 'DL3008', '--ignore', 'DL3009']
```

## Hook List

Full list of enabled hooks:

| Hook | Purpose | Auto-fix |
|------|---------|----------|
| trailing-whitespace | Remove trailing spaces | ✓ |
| end-of-file-fixer | Ensure newline at EOF | ✓ |
| check-yaml | Validate YAML syntax | ✗ |
| check-json | Validate JSON syntax | ✗ |
| shellcheck | Lint shell scripts | ✗ |
| terraform-fmt | Format Terraform | ✓ |
| terraform-validate | Validate Terraform | ✗ |
| checkov | Security scanning | ✗ |
| ansible-lint | Lint Ansible | ✗ |
| black | Format Python | ✓ |
| flake8 | Lint Python | ✗ |
| hadolint | Lint Dockerfile | ✗ |
| markdownlint | Lint Markdown | ✓ |
| detect-secrets | Find secrets | ✗ |
| conventional-pre-commit | Validate commit msg | ✗ |

## Contributing

When adding new file types or tools, update `.pre-commit-config.yaml` with appropriate hooks.
