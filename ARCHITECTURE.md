# DevContainer Architecture

```
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
│  │  │         Ubuntu 22.04 Base                   │        │ │
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
│  │  │  /workspace (Volume)  ← Persistent Storage        ││ │
│  │  │  /home/vscode         ← User Home Directory       ││ │
│  │  │  /tmp/scripts         ← Installation Scripts      ││ │
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

┌─────────────────────────────────────────────────────────────────┐
│                      Azure Cloud                                │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Azure ACR    │  │ Azure VM     │  │ Azure AKS    │         │
│  │ (Images)     │  │ (Resources)  │  │ (K8s)        │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Key Vault    │  │ Storage      │  │ DevOps       │         │
│  │ (Secrets)    │  │ (State)      │  │ (CI/CD)      │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────────────┘

Build & Deployment Flow:
────────────────────────

Developer        Azure DevOps           ACR             DevContainer
   │                  │                  │                   │
   │─── Push Code ───▶│                  │                   │
   │                  │                  │                   │
   │                  │─── Build ───────▶│                   │
   │                  │    Image         │                   │
   │                  │                  │                   │
   │                  │◀─── Push ────────│                   │
   │                  │    Success       │                   │
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
