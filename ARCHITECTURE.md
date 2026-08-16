# DevContainer Architecture

```text
┌─────────────────────────────────────────────────────────────────┐
│                     VS Code DevContainer                         │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                    VS Code Client                          │ │
│  │  ┌──────────────────────────────────────────────────────┐ │ │
│  │  │  Extensions:                                        │ │ │
│  │  │  • Docker • Terraform • Kubernetes • Azure CLI     │ │ │
│  │  │  • Python • PowerShell • Ansible • GitLens         │ │ │
│  │  └──────────────────────────────────────────────────────┘ │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │              Container Runtime Environment                 │ │
│  │                                                            │ │
│  │  ┌──────────────────────────────────────────────┐        │ │
│  │  │         Ubuntu 24.04 Base                   │        │ │
│  │  └──────────────────────────────────────────────┘        │ │
│  │                                                            │ │
│  │  ┌──────────────┬──────────────┬──────────────┐          │ │
│  │  │ IaC Tools    │ Cloud Tools  │ Container    │          │ │
│  │  │              │              │ Tools        │          │ │
│  │  │ • Terraform  │ • Azure CLI  │ • Docker     │          │ │
│  │  │ • Terragrunt │ • az         │ • kubectl    │          │ │
│  │  │ • tflint     │              │ • helm       │          │ │
│  │  │ • checkov    │              │ • kubelogin  │          │ │
│  │  └──────────────┴──────────────┴──────────────┘          │ │
│  │                                                            │ │
│  │  ┌──────────────┬──────────────┬──────────────┐          │ │
│  │  │ Config Mgmt  │ Languages    │ Utilities    │          │ │
│  │  │              │              │              │          │ │
│  │  │ • Ansible    │ • Python 3   │ • jq         │          │ │
│  │  │              │ • PowerShell │ • yq         │          │ │
│  │  │              │ • Bash/ZSH   │ • git-crypt  │          │ │
│  │  └──────────────┴──────────────┴──────────────┘          │ │
│  │                                                            │ │
│  │  ┌──────────────────────────────────────────────────────┐│ │
│  │  │                  File System                        ││ │
│  │  │                                                     ││ │
│  │  │  /workspace (Volume)      ← Persistent Storage    ││ │
│  │  │  /home/vscode (Volume)    ← User Home (Persistent)││ │
│  │  │  /tmp/install-<tool>      ← Installation temp dirs││ │
│  │  │  /tmp-home                ← Default home template ││ │
│  │  └──────────────────────────────────────────────────────┘│ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ├──────────────────────┐
                              │                      │
                              ▼                      ▼
                   ┌────────────────────┐ ┌────────────────────┐
                   │   Docker Volume    │ │   Bind Mount       │
                   │   (dev-volume)     │ │   (Local Files)    │
                   │                    │ │                    │
                   │ • Workspace data   │ │ • Source code      │
                   │ • Configuration    │ │ • Scripts          │
                   │ • State files      │ │ • Configs          │
                   └────────────────────┘ └────────────────────┘

External Connections:
─────────────────────

What the tooling inside the container reaches out to. This is not where the
image itself comes from - see the build flow below for that.

┌─────────────────────────────────────────────────────────────────┐
│                      Azure Cloud                                │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Azure ACR    │  │ Azure VM     │  │ Azure AKS    │         │
│  │ (Registries) │  │ (Resources)  │  │ (K8s)        │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Key Vault    │  │ Storage      │  │ Entra ID     │         │
│  │ (Secrets)    │  │ (State)      │  │ (Auth)       │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────────────┘

Build & Deployment Flow:
────────────────────────

Developer      GitHub Actions          GHCR            DevContainer
   │                  │                  │                   │
   │─── Push Code ───▶│                  │                   │
   │                  │                  │                   │
   │                  │─── Build ────────┤                   │
   │                  │    amd64 + arm64 │                   │
   │                  │    native runners│                   │
   │                  │                  │                   │
   │                  │─── Test ─────────┤                   │
   │                  │    in the image  │                   │
   │                  │                  │                   │
   │                  │─── Push ────────▶│                   │
   │                  │    by digest     │                   │
   │                  │                  │                   │
   │                  │─── Merge ───────▶│                   │
   │                  │    manifest list │                   │
   │                  │                  │                   │
   │                  │─── Attest ──────▶│                   │
   │                  │    SLSA build    │                   │
   │                  │                  │                   │
   │─────────────── Pull Image ─────────────────────────────▶│
   │                  │                  │                   │
   │◀──────────────── Development ──────────────────────────┘

Tool Interaction Flow:
─────────────────────

   User Input (VS Code)
          │
          ▼
   ┌─────────────┐
   │  Terraform  │──────────▶ Azure Resources
   │  Terragrunt │
   └─────────────┘
          │
          ├──────▶ tflint (Linting)
          └──────▶ checkov (Security)

   ┌─────────────┐
   │  Kubectl    │──────────▶ Kubernetes Cluster
   │  Helm       │
   └─────────────┘
          │
          └──────▶ kubelogin (Auth)

   ┌─────────────┐
   │  Docker     │──────────▶ Container Registry
   └─────────────┘

   ┌─────────────┐
   │  Ansible    │──────────▶ Target Servers
   └─────────────┘
```

## CI/CD Architecture

The build lives in three workflows under `.github/workflows/`. `ci.yml` (pull
requests, pushes to `main`) and `release.yml` (weekly, or manual) are thin entry
points; both call the reusable `build.yml`, which holds every step that touches
the image. Splitting it this way means the pull request path and the release
path cannot diverge, which is the failure mode where a change passes CI and then
breaks the release.

### Why a hand-rolled matrix rather than `docker/github-builder`

Docker publishes a reusable workflow that distributes a multi-platform build
across runners and merges the manifest. It is the shorter route, and it was
rejected here for one reason: it supports neither loading the built image
locally nor running per-platform tests against it. This repository's whole
value is the tools inside the image, so `tests/run-all-tests.sh` has to run
*inside* each built image before anything is published. That requires
`load: true`, which the reusable workflow does not offer.

### Why native runners rather than QEMU

`linux/amd64` builds on `ubuntu-24.04` and `linux/arm64` on `ubuntu-24.04-arm`,
each compiling for its own architecture. Emulating arm64 under QEMU on an x64
runner would be an order of magnitude slower on an image this size, against a
six-hour job limit. Both runner types are free and unlimited on public
repositories, so the matrix costs nothing.

The consequence is that install scripts must never hardcode an architecture -
hence `_arch.sh`. One tool diverges: Microsoft publishes the `powershell` deb
for amd64 only, so arm64 installs PowerShell from the upstream tarball.

### Build, test, then push

Each architecture builds once with `load: true`, runs the test suite against the
loaded image, and only then runs the build again with `push-by-digest`. The
second build is a cache hit, so it costs only the registry export. A final job
merges the per-architecture digests into one manifest list and attests it.

Disk is the binding constraint. Runners ship with roughly 14 GB free, which is
not enough for the BuildKit cache plus a loaded image of this size, so every
build job reclaims space first.

### Versioning and reproducibility

Releases are calendar-versioned. Almost every entry in `versions.json` is
"install latest", so the image genuinely is a point-in-time snapshot, and
semantic versioning would imply a compatibility contract the build cannot
honour. A digest is the only stable identifier; releases record theirs.

### Supply chain

BuildKit generates full provenance for each pushed image, and `actions/attest`
signs the merged manifest with a short-lived Sigstore certificate, pushing the
attestation to the registry as an OCI referrer. That single mechanism covers
signing - a separate cosign step would sign the same digest a second time with
the same trust root, and was left out for that reason.

The SBOM is deliberately not a BuildKit attestation. BuildKit bundles one as an
in-toto statement and enforces a 40 MiB ceiling on it; this image's SPDX document
runs to about 52 MB per architecture, and the ceiling only started being enforced
in BuildKit v0.32, which broke the weekly release with no change to this
repository. Syft scans the tested image in the build job instead, and each
release carries one SPDX document per architecture. The size that made the
attestation impossible is inherent - a container this broad has some 6,800
packages and 50,000 catalogued files - so the fix was to stop routing it through
a mechanism with a cap we do not control.

Trivy scans report to the Security tab and never gate the publish. An image
bundling the Azure CLI, Ansible and a .NET SDK carries upstream HIGH findings at
essentially all times; gating on them would halt the weekly rebuild, and a
stalled rebuild leaves users on an older image with strictly more vulnerabilities
than the one that was blocked.
