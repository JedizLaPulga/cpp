#!/usr/bin/env bash
set -euo pipefail

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$TEST_DIR/.." && pwd)"

"$PROJECT_ROOT/scripts/build.sh"

g++ -std=c++17 \
  -I"$PROJECT_ROOT/build/include" \
  -L"$PROJECT_ROOT/build" \
  -Wl,-rpath,"$PROJECT_ROOT/build" \
  -o "$TEST_DIR/test_datetime" \
  "$TEST_DIR/main.cpp" \
  -ldatetime

"$TEST_DIR/test_datetime"
