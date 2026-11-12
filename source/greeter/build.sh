#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$ROOT_DIR/dist"

ldc2 \
  --betterC \
  --shared \
  --HCf="$ROOT_DIR/dist/greeter.hpp" \
  -of="$ROOT_DIR/dist/libgreeter.so" \
  "$ROOT_DIR/source/greeter.d"
