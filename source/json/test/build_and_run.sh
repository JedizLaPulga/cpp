#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$ROOT_DIR/.." && pwd)"

# Compile the test
g++ -std=c++17 \
    -I"$PROJECT_ROOT" \
    -L"$PROJECT_ROOT/dist" \
    -Wl,-rpath,"$PROJECT_ROOT/dist" \
    -o "$ROOT_DIR/test_json" \
    "$ROOT_DIR/main.cpp" \
    -ljson

echo "✓ Test binary built: $ROOT_DIR/test_json"
echo ""
echo "Running tests..."
echo "================="
"$ROOT_DIR/test_json"
