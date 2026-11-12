#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$ROOT_DIR/dist"

ldc2 \
  --shared \
  --HCf="$ROOT_DIR/dist/json.hpp" \
  -of="$ROOT_DIR/dist/libjson.so" \
  "$ROOT_DIR/source/json.d"
