#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

"$ROOT_DIR/build.sh"

g++ -std=c++17 \
  test/main.cpp \
  -I"$ROOT_DIR/dist" \
  -L"$ROOT_DIR/dist" \
  -Wl,-rpath,"$ROOT_DIR/dist" \
  -lgreeter \
  -o test/main

./test/main
