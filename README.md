# DevOps Development Container

A comprehensive development container for DevOps and Infrastructure-as-Code workflows, built on Ubuntu 24.04 with essential tools for cloud infrastructure management, container orchestration, and automation.

## 🚀 Features

This devcontainer includes pre-configured tools for:

- **Infrastructure as Code**: Terraform, Terragrunt, tflint, checkov
- **Cloud Management**: Azure CLI (az)
- **Container Operations**: Docker Engine, Helm, kubectl, kubelogin
- **Configuration Management**: Ansible with 9 popular collections
- **Scripting & Automation**: PowerShell 7 with modules, Python with DevOps tools, ZSH with Oh My Zsh
- **Development Utilities**: Custom bash/zsh aliases, shell completions, git-crypt, pre-commit
- **Data Processing**: jq, yq

## 📋 Included Tools

| Tool | Purpose |
|------|---------|
| Terraform | Infrastructure provisioning |
| Terragrunt | Terraform wrapper for DRY configurations |
| Azure CLI | Azure cloud management |
| Docker | Container runtime and management |
| Helm | Kubernetes package manager |
| kubectl | Kubernetes cluster management |
| Ansible | Configuration management and automation |
| PowerShell | Cross-platform automation and scripting |
| Python | Scripting with DevOps-focused packages |

## 🏗️ Repository Structure

```
devcontainer/
├── .devcontainer/
│   ├── Dockerfile              # Multi-stage container build
│   ├── devcontainer.json       # VS Code devcontainer configuration
│   └── files/
│       ├── install/            # Installation scripts (each uses /tmp/install-<tool>)
│       │   ├── install-ansible.sh
│       │   ├── install-azure-cli.sh
│       │   ├── install-checkov.sh
│       │   ├── install-docker.sh
│       │   ├── install-git-crypt.sh
│       │   ├── install-helm.sh
│       │   ├── install-jq.sh
│       │   ├── install-kubelogin.sh
│       │   ├── install-kubectl.sh
│       │   ├── install-powershell.sh
│       │   ├── install-pre-commit.sh
│       │   ├── install-python-tools.sh
│       │   ├── install-terraform.sh
│       │   ├── install-terragrunt.sh
│       │   ├── install-tflint.sh
│       │   ├── install-yq.sh
│       │   └── install-zsh.sh
│       ├── home/               # Home directory files
│       │   ├── .bash_aliases   # Convenience aliases
│       │   ├── .environment    # Shell-aware environment config
│       │   └── .zshrc          # ZSH configuration
│       └── entrypoint.sh       # Container entrypoint for home dir init
├── tests/
│   ├── integration-test.sh     # Integration tests
│   ├── run-all-tests.sh        # Test runner
│   └── validate-tools.sh       # Tool validation
├── scripts/
│   └── check-latest-versions.sh
├── azure-pipelines.yml         # CI/CD pipeline for ACR
├── ARCHITECTURE.md             # System architecture documentation
├── CHANGELOG.md                # Version history
├── CONTRIBUTING.md             # Contribution guidelines
├── QUICKSTART.md               # Quick start guide
├── README.md                   # This file
├── SECURITY.md                 # Security policies
└── VERSION_MANAGEMENT.md       # Version management guide
```

## 🔧 Getting Started

### Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Quick Start

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd devcontainer
   ```

2. **Open in VS Code:**
   ```bash
   code .
   ```

3. **Reopen in Container:**
   - Press `F1` or `Ctrl+Shift+P`
   - Select `Dev Containers: Reopen in Container`
   - Wait for the container to build (first time takes longer)

4. **Start developing!**
   The container will be ready with all tools pre-installed.

## 💾 Storage Configuration

The devcontainer uses Docker volumes for persistent storage:

- **Workspace Volume**: `dev-workspace` mounted at `/workspace`
- **Home Volume**: `dev-home` mounted at `/home/vscode`
- **Bind Mount**: Local `.devcontainer` directory mounted at `/workspace/devcontainer`
- **Permissions**: Automatically configured via `postCreateCommand`
- **Home Init**: Entrypoint script copies default configs on first run

This ensures your work and settings persist across container rebuilds.

## 🔄 CI/CD Pipeline

An Azure DevOps pipeline is included to automatically build and push the container image to Azure Container Registry (ACR).

### Setup

1. **Create Azure Container Registry:**
   ```bash
   az acr create --resource-group <rg-name> --name <acr-name> --sku Basic
   ```

2. **Configure Azure DevOps:**
   - Create a Docker Registry service connection to your ACR
   - Update `azure-pipelines.yml` with your ACR name and service connection

3. **Pipeline Triggers:**
   - Automatically triggers on commits to `main` or `develop`
   - Monitors changes to `.devcontainer/` and `files/` directories

See [`.azuredevops/README.md`](.azuredevops/README.md) for detailed pipeline setup instructions.

## 🛠️ Customization

### Adding New Tools

1. Create an installation script in `files/scripts/`:
   ```bash
   files/scripts/install-your-tool.sh
   ```

2. Add the installation step to `Dockerfile`:
   ```dockerfile
   COPY ./files/scripts/install-your-tool.sh /tmp
   RUN sh /tmp/install-your-tool.sh
   ```

3. Rebuild the container

### Modifying Tool Versions

Update build arguments in `.devcontainer/devcontainer.json`:

```json
"args": {
    "UBUNTU_VERSION": "24.04",
    "TERRAFORM_VERSION": "1.13.5",
    "POWERSHELL_VERSION": "7.5.4",
    ...
}
```

## 📝 Usage Examples

### Terraform
```bash
terraform init
terraform plan
terraform apply
```

### Azure CLI
```bash
az login
az account list
az group create --name myResourceGroup --location eastus
```

### Docker
```bash
docker ps
docker build -t myimage .
docker run myimage
```

### Helm & Kubernetes
```bash
kubectl get pods
helm install myrelease mychart/
```

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Test in the devcontainer
4. Submit a pull request

## 📄 License

[Add your license information here]

## 🐛 Troubleshooting

### Container won't build
- Ensure Docker Desktop is running
- Check Docker has sufficient resources (CPU/Memory)
- Try rebuilding without cache: `Dev Containers: Rebuild Container`

### Permission issues in /workspace
- The `postCreateCommand` should handle this automatically
- Manually run: `sudo chown -R vscode:vscode /workspace`

### Tool not found
- Verify the installation script exists in `files/scripts/`
- Check the Dockerfile includes the COPY and RUN steps
- Rebuild the container

## 📞 Support

[Add contact information or support channels]
