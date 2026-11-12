#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <sandbox-name>"
  exit 1
fi

NAME="$1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SANDBOX_DIR="$ROOT_DIR/source/$NAME"

if [[ -e "$SANDBOX_DIR" ]]; then
  echo "Sandbox already exists: $SANDBOX_DIR"
  exit 1
fi

mkdir -p "$SANDBOX_DIR/source" "$SANDBOX_DIR/dist" "$SANDBOX_DIR/test"

cat > "$SANDBOX_DIR/dub.json" <<EOF
{
  "name": "$NAME",
  "description": "D sandbox producing a C++ header and shared library",
  "license": "proprietary",
  "targetType": "sourceLibrary",
  "targetPath": "dist",
  "targetName": "$NAME",
  "sourcePaths": [
    "source"
  ]
}
EOF

cat > "$SANDBOX_DIR/source/$NAME.d" <<EOF
module $NAME;

extern(C) nothrow @nogc:

const(char)* ${NAME}_message()
{
    return "Hello from D ($NAME)\\0".ptr;
}
EOF

cat > "$SANDBOX_DIR/build.sh" <<EOF
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "\$ROOT_DIR/dist"

ldc2 \\
  --betterC \\
  --shared \\
  --HCf="\$ROOT_DIR/dist/$NAME.hpp" \\
  -of="\$ROOT_DIR/dist/lib$NAME.so" \\
  "\$ROOT_DIR/source/$NAME.d"
EOF

cat > "$SANDBOX_DIR/test/main.cpp" <<EOF
#include <iostream>
#include "$NAME.hpp"

int main() {
    std::cout << ${NAME}_message() << '\\n';
    return 0;
}
EOF

cat > "$SANDBOX_DIR/test/run.sh" <<EOF
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")/.." && pwd)"

cd "\$ROOT_DIR"
"\$ROOT_DIR/build.sh"

g++ -std=c++17 \\
  test/main.cpp \\
  -I"\$ROOT_DIR/dist" \\
  -L"\$ROOT_DIR/dist" \\
  -Wl,-rpath,"\$ROOT_DIR/dist" \\
  -l$NAME \\
  -o test/main

./test/main
EOF

chmod +x "$SANDBOX_DIR/build.sh" "$SANDBOX_DIR/test/run.sh"

echo "Created sandbox: $SANDBOX_DIR"
