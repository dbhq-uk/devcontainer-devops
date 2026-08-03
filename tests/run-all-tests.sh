#!/bin/bash
# Run all tests

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running validation tests..."
bash "$SCRIPT_DIR/validate-tools.sh"

echo ""
echo "Running integration tests..."
bash "$SCRIPT_DIR/integration-test.sh"

echo ""
echo "==================================="
echo "All tests completed successfully!"
echo "==================================="
