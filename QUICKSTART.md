# Quick Start Guide

Get up and running with the DevOps DevContainer in 5 minutes!

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) running
- [VS Code](https://code.visualstudio.com/) installed
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed

## Steps

### 1. Clone the Repository

```bash
git clone <repository-url>
cd devcontainer
```

### 2. Open in VS Code

```bash
code .
```

### 3. Open in Container

When prompted, click **"Reopen in Container"**

Or manually:
- Press `F1` or `Ctrl+Shift+P`
- Type: `Dev Containers: Reopen in Container`
- Press Enter

### 4. Wait for Build

First build takes 5-10 minutes. Subsequent builds are much faster.

### 5. Verify Installation

Once inside the container, run:

```bash
validate
```

This checks all tools are installed correctly.

## What's Included?

✅ Terraform & Terragrunt  
✅ Azure CLI  
✅ Docker & Kubernetes (kubectl, helm)  
✅ Ansible  
✅ PowerShell 7  
✅ Python 3 with DevOps tools  
✅ Security scanners (tflint, checkov)  
✅ Data tools (jq, yq)  

## Common Commands

```bash
# Terraform
tf init
tf plan
tf apply

# Azure
az login
az account list

# Kubernetes
k get pods
helm list

# Docker
docker ps
docker images

# Run tests
testall
```

## Next Steps

- Review [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines
- Check [ARCHITECTURE.md](ARCHITECTURE.md) for system design
- Set up [pre-commit hooks](.pre-commit/README.md)
- Explore [variants](.devcontainer/variants/README.md) for cloud-specific setups

## Troubleshooting

### Container won't start
```bash
# Rebuild without cache
F1 → Dev Containers: Rebuild Container Without Cache
```

### Tools not found
```bash
# Verify PATH
echo $PATH

# Re-source environment
source ~/.bashrc
```

### Permission issues
```bash
# Fix workspace permissions
sudo chown -R vscode:vscode /workspace
```

## Need Help?

- Check [README.md](README.md) for full documentation
- Review [SECURITY.md](SECURITY.md) for security best practices
- Open an issue on GitHub

Happy coding! 🚀
