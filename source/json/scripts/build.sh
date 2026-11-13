#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$ROOT_DIR/build/generated"

ldc2 \
  --shared \
  --HCf="$ROOT_DIR/build/generated/json_ffi.hpp" \
  -of="$ROOT_DIR/build/libjson.so" \
  "$ROOT_DIR/source/json.d"
