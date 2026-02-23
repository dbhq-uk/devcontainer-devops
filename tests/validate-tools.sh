#!/bin/bash
# Validation script to test all installed tools

set -e

echo "==================================="
echo "DevContainer Tools Validation"
echo "==================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

validate_tool() {
    local tool=$1
    local version_cmd=$2
    
    echo -n "Checking $tool... "
    if command -v $tool &> /dev/null; then
        version=$($version_cmd 2>&1 | head -n 1)
        echo -e "${GREEN}✓ Installed${NC} - $version"
        return 0
    else
        echo -e "${RED}✗ Not found${NC}"
        return 1
    fi
}

# Track failures
FAILURES=0

# Core utilities
echo "Core Utilities:"
validate_tool "git" "git --version" || ((FAILURES++))
validate_tool "curl" "curl --version" || ((FAILURES++))
validate_tool "wget" "wget --version" || ((FAILURES++))
validate_tool "jq" "jq --version" || ((FAILURES++))
validate_tool "yq" "yq --version" || ((FAILURES++))
echo ""

# Infrastructure as Code
echo "Infrastructure as Code:"
validate_tool "terraform" "terraform version" || ((FAILURES++))
validate_tool "terragrunt" "terragrunt --version" || ((FAILURES++))
validate_tool "tflint" "tflint --version" || ((FAILURES++))
validate_tool "checkov" "checkov --version" || ((FAILURES++))
echo ""

# Cloud Tools
echo "Cloud Tools:"
validate_tool "az" "az version" || ((FAILURES++))
echo ""

# Container & Kubernetes
echo "Container & Kubernetes:"
validate_tool "docker" "docker --version" || ((FAILURES++))
validate_tool "kubectl" "kubectl version --client" || ((FAILURES++))
validate_tool "helm" "helm version" || ((FAILURES++))
validate_tool "kubelogin" "kubelogin --version" || ((FAILURES++))
echo ""

# Configuration Management
echo "Configuration Management:"
validate_tool "ansible" "ansible --version" || ((FAILURES++))
echo ""

# Programming Languages & Runtimes
echo "Programming Languages:"
validate_tool "python3" "python3 --version" || ((FAILURES++))
validate_tool "pip3" "pip3 --version" || ((FAILURES++))
validate_tool "pwsh" "pwsh --version" || ((FAILURES++))
validate_tool "node" "node --version" || ((FAILURES++))
validate_tool "npm" "npm --version" || ((FAILURES++))
echo ""

# AI Tools
echo "AI Tools:"
validate_tool "claude" "claude --version" || ((FAILURES++))
echo ""

# Security Tools
echo "Security Tools:"
validate_tool "git-crypt" "git-crypt --version" || ((FAILURES++))
echo ""

# Test Python packages
echo "Python Packages:"
python3 -c "import requests; print('requests: ' + requests.__version__)" && echo -e "${GREEN}✓ requests installed${NC}" || ((FAILURES++))
python3 -c "import jmespath; print('jmespath: ' + jmespath.__version__)" && echo -e "${GREEN}✓ jmespath installed${NC}" || ((FAILURES++))
echo ""

# Summary
echo "==================================="
if [ $FAILURES -eq 0 ]; then
    echo -e "${GREEN}All validations passed!${NC}"
    exit 0
else
    echo -e "${RED}$FAILURES validation(s) failed!${NC}"
    exit 1
fi
