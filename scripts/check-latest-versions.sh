#!/bin/bash
# Script to fetch and display latest versions of all tools
# This helps keep the devcontainer up to date

set -e

echo "=================================="
echo "Fetching Latest Tool Versions"
echo "=================================="
echo ""

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

get_github_latest() {
    local repo=$1
    local current=$2
    echo -n "Checking ${repo}... "
    latest=$(curl -s "https://api.github.com/repos/${repo}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v?([^"]+)".*/\1/')
    if [ -n "$latest" ]; then
        echo -e "${GREEN}${latest}${NC} (current: ${current})"
        echo "$latest"
    else
        echo "Failed to fetch"
        echo "$current"
    fi
}

# Terraform
echo -e "${BLUE}Terraform:${NC}"
TF_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r '.current_version')
echo -e "  Latest: ${GREEN}${TF_LATEST}${NC}"
echo ""

# Terragrunt
echo -e "${BLUE}Terragrunt:${NC}"
TG_LATEST=$(get_github_latest "gruntwork-io/terragrunt" "0.70.4")
echo ""

# kubectl
echo -e "${BLUE}kubectl:${NC}"
KUBECTL_LATEST=$(curl -L -s https://dl.k8s.io/release/stable.txt | sed 's/v//')
echo -e "  Latest: ${GREEN}${KUBECTL_LATEST}${NC}"
echo ""

# Helm
echo -e "${BLUE}Helm:${NC}"
HELM_LATEST=$(get_github_latest "helm/helm" "4.0.0")
echo ""

# Azure CLI
echo -e "${BLUE}Azure CLI:${NC}"
AZ_LATEST=$(curl -s https://api.github.com/repos/Azure/azure-cli/releases/latest | grep '"tag_name":' | sed -E 's/.*"azure-cli-([^"]+)".*/\1/')
echo -e "  Latest: ${GREEN}${AZ_LATEST}${NC}"
echo ""

# PowerShell
echo -e "${BLUE}PowerShell:${NC}"
PWSH_LATEST=$(get_github_latest "PowerShell/PowerShell" "7.5.4")
echo ""

# kubelogin
echo -e "${BLUE}kubelogin:${NC}"
KUBELOGIN_LATEST=$(get_github_latest "Azure/kubelogin" "0.1.9")
echo ""

# yq
echo -e "${BLUE}yq:${NC}"
YQ_LATEST=$(get_github_latest "mikefarah/yq" "4.44.6")
echo ""

# jq
echo -e "${BLUE}jq:${NC}"
JQ_LATEST=$(get_github_latest "jqlang/jq" "1.7.1")
echo ""

# tflint
echo -e "${BLUE}tflint:${NC}"
TFLINT_LATEST=$(get_github_latest "terraform-linters/tflint" "0.54.0")
echo ""

# Ansible
echo -e "${BLUE}Ansible:${NC}"
ANSIBLE_LATEST=$(curl -s https://pypi.org/pypi/ansible/json | jq -r '.info.version')
echo -e "  Latest: ${GREEN}${ANSIBLE_LATEST}${NC}"
echo ""

# Checkov
echo -e "${BLUE}Checkov:${NC}"
CHECKOV_LATEST=$(curl -s https://pypi.org/pypi/checkov/json | jq -r '.info.version')
echo -e "  Latest: ${GREEN}${CHECKOV_LATEST}${NC}"
echo ""

# Node.js
echo -e "${BLUE}Node.js LTS:${NC}"
NODE_LATEST=$(curl -s https://nodejs.org/dist/index.json | jq -r '[.[] | select(.lts != false)][0].version' | sed 's/v//')
echo -e "  Latest LTS: ${GREEN}${NODE_LATEST}${NC}"
echo ""

# Claude Code
echo -e "${BLUE}Claude Code:${NC}"
CLAUDE_LATEST=$(curl -s https://registry.npmjs.org/@anthropic-ai/claude-code/latest | jq -r '.version')
echo -e "  Latest: ${GREEN}${CLAUDE_LATEST}${NC}"
echo ""

echo "=================================="
echo "Update devcontainer.json with:"
echo "=================================="
cat << EOF

"args": {
    "UBUNTU_VERSION": "22.04",
    "TERRAFORM_VERSION": "${TF_LATEST}",
    "TERRAGRUNT_VERSION": "${TG_LATEST}",
    "KUBECTL_VERSION": "${KUBECTL_LATEST}",
    "HELM_VERSION": "${HELM_LATEST}",
    "AZ_CLI_VERSION": "${AZ_LATEST}",
    "ANSIBLE_VERSION": "${ANSIBLE_LATEST}",
    "POWERSHELL_VERSION": "${PWSH_LATEST}",
    "KUBELOGIN_VERSION": "${KUBELOGIN_LATEST}",
    "YQ_VERSION": "${YQ_LATEST}",
    "JQ_VERSION": "${JQ_LATEST}",
    "TFLINT_VERSION": "${TFLINT_LATEST}",
    "CHECKOV_VERSION": "${CHECKOV_LATEST}"
}

EOF
