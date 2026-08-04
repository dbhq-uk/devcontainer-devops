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

```text
devcontainer-devops/
├── .github/
│   └── workflows/
│       ├── build.yml           # Reusable build: lint, build, test, scan, publish
│       ├── ci.yml              # Pull requests and pushes to main
│       └── release.yml         # Weekly CalVer release
├── .devcontainer/
│   ├── Dockerfile              # Multi-stage container build
│   ├── devcontainer.json       # VS Code devcontainer configuration
│   └── files/
│       ├── install/            # Installation scripts (each uses /tmp/install-<tool>)
│       │   ├── _arch.sh        # Sourced helper: architecture detection
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
├── .hadolint.yaml              # Dockerfile lint rules, shared by CI and pre-commit
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
   git clone https://github.com/grinidx/devcontainer-devops.git
   cd devcontainer-devops
   ```

2. **Open in VS Code:**

   ```bash
   code .
   ```

3. **Reopen in Container:**
   - Press `F1` or `Ctrl+Shift+P`
   - Select `Dev Containers: Reopen in Container`
   - The pre-built image is pulled from GHCR, so there is no wait for a build

4. **Start developing!**
   The container will be ready with all tools pre-installed.

### Using the image directly

You do not need this repository to use the container. Point any
`devcontainer.json` at the published image, or pull it yourself:

```bash
docker pull ghcr.io/grinidx/devcontainer-devops:latest
```

| Tag | What it is |
|-----|------------|
| `latest` | The most recent weekly release |
| `2026.08.09` | A specific weekly release |
| `2026.08` | The most recent release in that month |
| `main` | Head of the default branch, rebuilt on every push |
| `sha-abc1234` | One specific commit |

Images are published for `linux/amd64` and `linux/arm64`; Docker picks the
right one automatically.

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

## 🔄 CI/CD

GitHub Actions builds, tests and publishes the image to the GitHub Container
Registry. There is nothing to configure - it runs on the repository's own
`GITHUB_TOKEN`, with no secrets and no external registry account.

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| [`ci.yml`](.github/workflows/ci.yml) | Pull requests | Lints, builds both architectures, runs the test suite. Publishes nothing |
| [`ci.yml`](.github/workflows/ci.yml) | Push to `main` | The same, then publishes `:main` and `:sha-<short>` |
| [`release.yml`](.github/workflows/release.yml) | Sundays 03:00 UTC, or manually | A `--no-cache` rebuild, published as a dated release and `:latest` |

Both call [`build.yml`](.github/workflows/build.yml), which holds the actual
build so the two entry points cannot drift apart.

### How a build works

Each architecture builds on its own native runner - `ubuntu-24.04` and
`ubuntu-24.04-arm` - rather than under QEMU emulation, which would take hours
for an image this size. Each runner builds its platform, loads it locally, runs
[`tests/run-all-tests.sh`](tests/run-all-tests.sh) against the real image, and
only then pushes by digest. A final job merges the digests into one
multi-architecture manifest.

### Versioning

Releases are calendar-versioned: `v2026.08.09` is the image as it was built on
that date. Most entries in `versions.json` are "install latest", so a tag is a
point-in-time snapshot rather than a reproducible build - rebuilding the same
tag a week later would produce a different image. **If you need one exact
image, pin the digest**, which every release records.

### Supply chain

Every published image carries an SBOM and SLSA build provenance, generated by
BuildKit and signed with a short-lived [Sigstore](https://www.sigstore.dev/)
certificate. Verify that an image really came from this repository:

```bash
gh attestation verify oci://ghcr.io/grinidx/devcontainer-devops:latest \
  -R grinidx/devcontainer-devops
```

Read the SBOM out of the image:

```bash
docker buildx imagetools inspect ghcr.io/grinidx/devcontainer-devops:latest \
  --format '{{ json .SBOM }}'
```

Trivy scans each build for HIGH and CRITICAL vulnerabilities and reports them
to the repository's Security tab. Scans report, they do not block: an image
bundling the Azure CLI, Ansible and a .NET SDK always carries some upstream
findings, and blocking on those would stop the weekly rebuild and leave the
published image staler than the CVEs it was avoiding.

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

   **The image is built for `amd64` and `arm64`, so never hardcode an
   architecture.** Source the shared helper and use the spelling your upstream
   uses:

   ```bash
   . "$(dirname "$0")/_arch.sh"
   # ARCH_DEB  amd64  / arm64     Debian and Go convention, most releases
   # ARCH_X64  x64    / arm64     e.g. gitleaks
   # ARCH_GNU  x86_64 / aarch64   Rust target triples, e.g. uv
   ```

   If the tool has no `arm64` Linux build, say so in a comment and skip it on
   that architecture rather than failing the build.

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

> CI does **not** pass these build args, so published images install the latest
> of everything left unpinned in the `Dockerfile`. That is deliberate - see
> [Versioning](#versioning) - and it is why a release tag is a snapshot rather
> than a reproducible build.

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

MIT - see [`LICENSE`](LICENSE).

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

Open an [issue](https://github.com/grinidx/devcontainer-devops/issues). For
anything security-related, follow [`SECURITY.md`](SECURITY.md) instead of
opening a public issue.
