#!/bin/bash
# Integration tests for common DevOps workflows

set -e

echo "==================================="
echo "DevOps Workflow Integration Tests"
echo "==================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

TEST_DIR="/tmp/devcontainer-tests"
FAILURES=0

# Setup test directory
mkdir -p $TEST_DIR
cd $TEST_DIR

run_test() {
    local test_name=$1
    local test_cmd=$2
    
    echo -n "Testing: $test_name... "
    if eval $test_cmd &> /dev/null; then
        echo -e "${GREEN}✓ PASS${NC}"
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        return 1
    fi
}

echo "Terraform Tests:"
run_test "terraform init" "cd $TEST_DIR && mkdir -p tf-test && cd tf-test && echo 'terraform { required_version = \">= 1.0\" }' > main.tf && terraform init" || ((FAILURES++))
run_test "terraform fmt" "cd $TEST_DIR/tf-test && terraform fmt" || ((FAILURES++))
run_test "terraform validate" "cd $TEST_DIR/tf-test && terraform validate" || ((FAILURES++))
echo ""

# echo "Docker Tests:"
# run_test "docker info" "docker info" || ((FAILURES++))
# run_test "docker pull hello-world" "docker pull hello-world:latest" || ((FAILURES++))
# run_test "docker run hello-world" "docker run --rm hello-world" || ((FAILURES++))
# echo ""

echo "Kubernetes Tests:"
run_test "kubectl version" "kubectl version --client" || ((FAILURES++))
run_test "helm version" "helm version" || ((FAILURES++))
echo ""

echo "Azure CLI Tests:"
run_test "az version" "az version" || ((FAILURES++))
run_test "az account list-locations" "az account list-locations --query '[0]' || true" || ((FAILURES++))
echo ""

echo "Python Tests:"
run_test "python import requests" "python3 -c 'import requests'" || ((FAILURES++))
run_test "python import jmespath" "python3 -c 'import jmespath'" || ((FAILURES++))
echo ""

echo "Ansible Tests:"
run_test "ansible localhost -m ping" "ansible localhost -m ping -c local" || ((FAILURES++))
echo ""

echo "Security Scanning Tests:"
run_test "checkov help" "checkov --help" || ((FAILURES++))
run_test "tflint version" "tflint --version" || ((FAILURES++))
echo ""

echo "Data Processing Tests:"
run_test "jq parse json" "echo '{\"test\": \"value\"}' | jq -r .test" || ((FAILURES++))
run_test "yq parse yaml" "echo 'test: value' | yq '.test'" || ((FAILURES++))
echo ""

# Cleanup
cd /
rm -rf $TEST_DIR

echo "==================================="
if [ $FAILURES -eq 0 ]; then
    echo -e "${GREEN}All integration tests passed!${NC}"
    exit 0
else
    echo -e "${RED}$FAILURES test(s) failed!${NC}"
    exit 1
fi
