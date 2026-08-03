# DevOps Development Container

A comprehensive development container for DevOps and Infrastructure-as-Code workflows, built on Ubuntu 24.04 with essential tools for cloud infrastructure management, container orchestration, and automation.

## 🚀 Features

This devcontainer includes pre-configured tools for:

- **Infrastructure as Code**: Terraform, Terragrunt, tflint, tf-summarize, checkov
- **Cloud Management**: Azure CLI (az), AzCopy
- **Container Operations**: Docker Engine, Helm, kubectl, kubelogin
- **Configuration Management**: Ansible with 9 popular collections
- **Scripting & Automation**: PowerShell 7 with modules, Python with DevOps tools, uv, Node.js, ZSH with Oh My Zsh
- **.NET Development**: .NET 10 SDK (LTS) with C# and C# Dev Kit extensions
- **AI Tooling**: Claude Code, Codex, cswap (Claude Code account switcher)
- **Security**: git-crypt, gitleaks, checkov, optional custom CA trust chain
- **Development Utilities**: Custom bash/zsh aliases, shell completions, pre-commit
- **Data Processing**: jq, yq

## 📋 Included Tools

| Tool | Purpose |
|------|---------|
| Terraform | Infrastructure provisioning |
| Terragrunt | Terraform wrapper for DRY configurations |
| tflint | Terraform linting |
| tf-summarize | Human-readable Terraform plan summaries |
| checkov | IaC security and compliance scanning |
| Azure CLI | Azure cloud management |
| AzCopy | Bulk transfer to/from Azure Storage |
| Docker | Container runtime and management |
| Helm | Kubernetes package manager |
| kubectl | Kubernetes cluster management |
| kubelogin | Azure AD authentication for kubectl |
| Ansible | Configuration management and automation |
| PowerShell | Cross-platform automation and scripting |
| Python | Scripting with DevOps-focused packages |
| uv | Fast Python package/project manager (`uv`, `uvx`) |
| Node.js | JavaScript runtime and npm tooling |
| .NET SDK | C# / .NET 10 application development |
| Claude Code | Anthropic coding agent (self-updating, user-tree install) |
| Codex | OpenAI coding agent (run `codex-init` to configure) |
| cswap | Switch between Claude Code accounts (`claude-swap`) |
| git-crypt | Transparent encryption of files in git |
| gitleaks | Secret scanning |
| pre-commit | Git hook framework |
| jq / yq | JSON and YAML processing |

> `jq`, `zsh` and the other base utilities come from the apt package list and the
> upstream devcontainer base image rather than a dedicated `install-*.sh` script —
> which is why they have no entry in the `install/` tree above.
>
> `uv` is available for interactive use, but no tool in this image is installed
> through it — the Python-based tools (checkov, claude-swap, ansible) still use
> system-wide `pip`.

## 🏗️ Repository Structure

```
devcontainer/
├── .devcontainer/
│   ├── Dockerfile              # Multi-stage container build
│   ├── devcontainer.json       # VS Code devcontainer configuration
│   └── files/
│       ├── install/            # Installation scripts (each uses /tmp/install-<tool>)
│       │   ├── install-ansible.sh
│       │   ├── install-azcopy.sh
│       │   ├── install-azure-cli.sh
│       │   ├── install-checkov.sh
│       │   ├── install-claude-code.sh
│       │   ├── install-codex.sh
│       │   ├── install-cswap.sh
│       │   ├── install-docker.sh
│       │   ├── install-dotnet.sh
│       │   ├── install-git-crypt.sh
│       │   ├── install-gitleaks.sh
│       │   ├── install-helm.sh
│       │   ├── install-kubectl.sh
│       │   ├── install-kubelogin.sh
│       │   ├── install-node.sh
│       │   ├── install-powershell.sh
│       │   ├── install-pre-commit.sh
│       │   ├── install-python-tools.sh
│       │   ├── install-terraform.sh
│       │   ├── install-terragrunt.sh
│       │   ├── install-tf-summarize.sh
│       │   ├── install-tflint.sh
│       │   ├── install-uv.sh
│       │   └── install-yq.sh
│       ├── certs/              # Drop-in dir for extra CA certificates
│       │   └── README.md       # How to add your own CA chain
│       ├── codex/              # Codex bootstrap (rendered by `codex-init`)
│       │   ├── codex-init
│       │   └── config.toml.tmpl
│       ├── home/               # Home directory files
│       │   ├── .bash_aliases   # Convenience aliases
│       │   ├── .environment    # Shell-aware environment config
│       │   ├── .zshrc          # ZSH configuration
│       │   ├── .claude/        # Claude Code defaults
│       │   └── .config/        # PowerShell profile and theme
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

- **Workspace Volume**: `dev-workspace-<user>` mounted at `/workspace`
- **Home Volume**: `dev-home-<user>` mounted at `/home/vscode`
- **Bind Mount**: The local workspace folder mounted at `/workspace/devcontainer`
- **Permissions**: Automatically configured via `postCreateCommand`
- **Home Init**: Entrypoint script copies default configs on first run

This ensures your work and settings persist across container rebuilds.

Both volumes are per-user (suffixed with `$USER`), so several checkouts can run
side by side without sharing state. Note that `/home/vscode` is only seeded from
the image's `/tmp-home` template on **first** start — tools installed into the
home tree do not refresh on rebuild for an existing volume, which is why most
tooling installs system-wide.

## 🔐 Custom CA Certificates

If your environment terminates TLS with a private CA, drop the PEM-encoded chain
into `.devcontainer/files/certs/` as a `*.crt` file before building. The
`Dockerfile` copies the directory to `/usr/local/share/ca-certificates/extra/`
and runs `update-ca-certificates`, merging it into the system bundle at
`/etc/ssl/certs/ca-certificates.crt`.

`REQUESTS_CA_BUNDLE`, `SSL_CERT_FILE` and `NODE_EXTRA_CA_CERTS` all point at that
bundle, which covers Python (`az`, `ansible`, `checkov`, …), `curl`, and Node.js —
Node ignores the system store, so it has to be told explicitly.

Certificates are git-ignored (`*.crt`, `*.pem`), so nothing is committed by
accident. Adding none is fine: the build succeeds and the container trusts the
public roots from the base image. See
[`.devcontainer/files/certs/README.md`](.devcontainer/files/certs/README.md).

## 🔄 CI/CD Pipeline

An Azure DevOps pipeline is included to automatically build and push the container image to Azure Container Registry (ACR).

### Setup

1. **Create Azure Container Registry:**
   ```bash
   az acr create --resource-group <rg-name> --name <acr-name> --sku Basic
   ```

2. **Configure Azure DevOps:**
   - Create a Docker Registry service connection to your ACR
   - Replace the `<your-agent-pool>`, `<your-registry>` and
     `<your-registry-service-connection>` placeholders in `azure-pipelines.yml`
   - Either provide a `Dependency_track` variable group (supplying
     `Dependency_track_URL` and `Dependency_track_API_KEY`) or remove that
     variable group and the SBOM upload task

3. **Pipeline Triggers:**
   - Automatically triggers on commits to `master`
   - Weekly scheduled rebuild (Sundays, 00:00) using `--no-cache` so unpinned
     tools and the base image pick up upstream updates
   - Publishes an SBOM to Dependency Track

See [`azure-pipelines.yml`](azure-pipelines.yml) for the full pipeline definition.

## 🛠️ Customization

### Adding New Tools

1. Create an installation script in `.devcontainer/files/install/`. It should take
   the desired version as `$1`, resolve the latest when that argument is empty,
   and verify the install before exiting:

   ```bash
   .devcontainer/files/install/install-your-tool.sh
   ```

   The whole directory is copied and `chmod +x`'d in one step, so no `COPY` line
   is needed per script.

2. Add an `ARG YOUR_TOOL_VERSION=` to **both** blocks at the top of the
   `Dockerfile` (before and after the `FROM`), then invoke the script:

   ```dockerfile
   RUN /tmp/install/install-your-tool.sh ${YOUR_TOOL_VERSION}
   ```

   Place the `RUN` as late in the file as the dependencies allow — a version bump
   invalidates every layer after it.

3. Record the version in `versions.json`, add a `validate_tool` line to
   `tests/validate-tools.sh`, and note it in `CHANGELOG.md`.

4. Rebuild the container

### Modifying Tool Versions

`versions.json` is the documented source of truth for tool versions; an empty
string means "install latest". See [`VERSION_MANAGEMENT.md`](VERSION_MANAGEMENT.md)
for the per-tool version sources.

The `Dockerfile` ARGs default to empty (latest). `.devcontainer/devcontainer.json`
builds from the local `Dockerfile` by default — to pin, add the versions to its
`build.args` block:

```json
"args": {
    "UBUNTU_VERSION": "24.04",
    "TERRAFORM_VERSION": "1.13.5",
    "POWERSHELL_VERSION": "7.5.4"
}
```

> The CI pipeline does **not** currently pass these build args, so scheduled
> image builds install the latest of everything left unpinned in the `Dockerfile`.

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

### AI Tooling
```bash
claude                  # start Claude Code
codex-init              # one-off: configure Codex endpoint and deployment

cswap list              # list managed Claude Code accounts
cswap status            # show the account currently in use
cswap add               # register the account you are signed in as
cswap switch            # rotate to the next account
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
- Verify the installation script exists in `.devcontainer/files/install/`
- Check the `Dockerfile` has a `RUN /tmp/install/install-<tool>.sh` step
- Confirm it appears in `tests/validate-tools.sh`, then run that script
- Rebuild the container

### A home-directory tool is missing or stale after a rebuild
`/home/vscode` is a persistent per-user volume, seeded from the image only on
first start. Anything installed into the home tree (Claude Code, for example)
will not refresh for an existing volume. Remove the `dev-home-<user>` volume to
re-seed, or update the tool in place.

## 📞 Support

[Add contact information or support channels]
