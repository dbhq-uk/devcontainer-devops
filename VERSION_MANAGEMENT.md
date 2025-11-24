# Version Management

This devcontainer is designed to use the **latest versions** of all tools by default, with the ability to pin specific versions when needed.

## Default Behavior: Latest Versions

By default, when you build the container without specifying versions, it will automatically fetch and install the latest stable version of each tool:

- ✅ Terraform (latest)
- ✅ Terragrunt (latest)
- ✅ kubectl (latest stable)
- ✅ Helm (latest)
- ✅ Azure CLI (latest)
- ✅ PowerShell (latest)
- ✅ Ansible (latest)
- ✅ All other tools...

## How It Works

Each installation script checks if a version is provided:
- **No version**: Fetches latest from official source (GitHub API, PyPI, etc.)
- **Version provided**: Installs that specific version

## Pinning Versions

### Option 1: Via devcontainer.json (Recommended)

Edit `.devcontainer/build/devcontainer.json` or `.devcontainer/local/devcontainer.json`:

```json
{
    "build": {
        "args": {
            "UBUNTU_VERSION": "22.04",
            "TERRAFORM_VERSION": "1.13.5",     // Pin Terraform
            "KUBECTL_VERSION": "1.30.0",       // Pin kubectl
            "HELM_VERSION": "3.14.0"           // Pin Helm
            // Leave others empty for latest
        }
    }
}
```

### Option 2: Via Dockerfile

Edit `.devcontainer/Dockerfile` ARG section:

```dockerfile
ARG TERRAFORM_VERSION=1.13.5   # Pin this
ARG KUBECTL_VERSION=           # Use latest
ARG HELM_VERSION=3.14.0        # Pin this
```

### Option 3: Via Pipeline

In `azure-pipelines.yml`:

```yaml
arguments: |
  --build-arg TERRAFORM_VERSION=1.13.5
  --build-arg KUBECTL_VERSION=1.30.0
```

## Checking Current Versions

### Inside the Container

Run validation to see installed versions:
```bash
validate
```

### Before Building

Check what latest versions are available:
```bash
bash scripts/check-latest-versions.sh
```

This will:
- Fetch all latest versions
- Show current versions in your config
- Provide ready-to-use configuration

## Version Strategy Recommendations

### Development Environment
✅ **Use latest versions** for maximum features and security patches
```json
"args": {
    "UBUNTU_VERSION": "22.04"
    // No version pinning - always latest
}
```

### CI/CD Pipelines
⚠️ **Pin versions** for reproducibility
```json
"args": {
    "UBUNTU_VERSION": "22.04",
    "TERRAFORM_VERSION": "1.13.5",
    "KUBECTL_VERSION": "1.30.0",
    "HELM_VERSION": "3.14.0"
}
```

### Production Support
🔒 **Pin all versions** for stability
```json
"args": {
    "UBUNTU_VERSION": "22.04",
    "TERRAFORM_VERSION": "1.13.5",
    "TERRAGRUNT_VERSION": "0.70.4",
    "KUBECTL_VERSION": "1.30.0",
    "HELM_VERSION": "3.14.0",
    "AZ_CLI_VERSION": "2.79.0",
    "ANSIBLE_VERSION": "2.18.1",
    "POWERSHELL_VERSION": "7.5.4",
    "KUBELOGIN_VERSION": "0.1.9",
    "YQ_VERSION": "4.44.6",
    "JQ_VERSION": "1.7.1",
    "TFLINT_VERSION": "0.54.0",
    "CHECKOV_VERSION": "3.2.337"
}
```

## Update Workflow

### Regular Updates (Monthly Recommended)

1. **Check for updates:**
   ```bash
   bash scripts/check-latest-versions.sh
   ```

2. **Update configuration** with new versions if desired

3. **Rebuild container:**
   ```
   Dev Containers: Rebuild Container
   ```

4. **Test thoroughly:**
   ```bash
   validate
   testall
   ```

5. **Commit changes** to version control

### Emergency Security Update

If a critical security patch is released:

1. **Pin to secure version** in devcontainer.json:
   ```json
   "TERRAFORM_VERSION": "1.13.6"  // Security patch
   ```

2. **Rebuild immediately:**
   ```
   Dev Containers: Rebuild Container Without Cache
   ```

3. **Verify:**
   ```bash
   terraform version
   ```

## Version Sources

| Tool | Source | API/URL |
|------|--------|---------|
| Terraform | HashiCorp Checkpoint | `https://checkpoint-api.hashicorp.com/v1/check/terraform` |
| Terragrunt | GitHub Releases | `https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest` |
| kubectl | Kubernetes | `https://dl.k8s.io/release/stable.txt` |
| Helm | GitHub Releases | `https://api.github.com/repos/helm/helm/releases/latest` |
| Azure CLI | GitHub Releases | `https://api.github.com/repos/Azure/azure-cli/releases/latest` |
| PowerShell | GitHub Releases | `https://api.github.com/repos/PowerShell/PowerShell/releases/latest` |
| Ansible | PyPI | `https://pypi.org/pypi/ansible/json` |
| Checkov | PyPI | `https://pypi.org/pypi/checkov/json` |
| yq | GitHub Releases | `https://api.github.com/repos/mikefarah/yq/releases/latest` |
| jq | GitHub Releases | `https://api.github.com/repos/jqlang/jq/releases/latest` |
| tflint | GitHub Releases | `https://api.github.com/repos/terraform-linters/tflint/releases/latest` |
| kubelogin | GitHub Releases | `https://api.github.com/repos/Azure/kubelogin/releases/latest` |

## Compatibility Matrix

Some tools have dependencies on others. Check compatibility:

| Terraform Version | Compatible kubectl | Compatible Helm |
|-------------------|-------------------|-----------------|
| 1.9.x | 1.30.x - 1.31.x | 3.14.x - 3.16.x |
| 1.10.x | 1.31.x - 1.32.x | 3.15.x - 3.16.x |

Always test after updates!

## Troubleshooting

### Version fetch fails during build
```bash
# Fallback: The script will use hardcoded defaults
# Or manually specify version in devcontainer.json
```

### Incompatible versions
```bash
# Pin to known-good versions
"TERRAFORM_VERSION": "1.13.5",
"KUBECTL_VERSION": "1.30.0"
```

### Slow builds
```bash
# Version fetching adds ~30s to build
# Pin versions to skip API calls
```

## Best Practices

✅ **DO:**
- Use latest versions in development
- Pin versions in CI/CD
- Test after each update
- Document version requirements
- Check release notes before updating

❌ **DON'T:**
- Auto-update in production
- Skip testing after updates
- Mix latest and pinned randomly
- Ignore deprecation warnings

## Examples

### Pure Latest (Development)
```json
"args": {
    "UBUNTU_VERSION": "22.04"
}
```

### Mixed (Flexible Development)
```json
"args": {
    "UBUNTU_VERSION": "22.04",
    "TERRAFORM_VERSION": "1.13.5",  // Pin for project compatibility
    // Others use latest
}
```

### Fully Pinned (Production)
```json
"args": {
    "UBUNTU_VERSION": "22.04",
    "TERRAFORM_VERSION": "1.13.5",
    "KUBECTL_VERSION": "1.30.0",
    "HELM_VERSION": "3.14.0",
    "AZ_CLI_VERSION": "2.79.0",
    "ANSIBLE_VERSION": "2.18.1",
    "POWERSHELL_VERSION": "7.5.4"
}
```

---

**Remember**: Latest versions = latest features + security patches, but also potential breaking changes. Choose your strategy wisely! 🎯
