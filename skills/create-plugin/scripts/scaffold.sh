#!/usr/bin/env bash
set -euo pipefail

PLUGIN_NAME="${1:?Usage: scaffold.sh <plugin-name> [description]}"
DESCRIPTION="${2:-A Codex CLI plugin}"
TARGET_DIR="${3:-./$PLUGIN_NAME}"

if [ -d "$TARGET_DIR/.codex-plugin" ]; then
  echo "ERROR: $TARGET_DIR/.codex-plugin already exists"
  exit 1
fi

mkdir -p "$TARGET_DIR"/{.codex-plugin,skills,hooks,agents,assets}

cat > "$TARGET_DIR/.codex-plugin/plugin.json" <<EOF
{
  "name": "$PLUGIN_NAME",
  "version": "0.1.0",
  "description": "$DESCRIPTION",
  "author": {
    "name": "",
    "url": ""
  },
  "license": "MIT",
  "keywords": [],
  "skills": "./skills/",
  "hooks": "./hooks/hooks.json",
  "interface": {
    "displayName": "$PLUGIN_NAME",
    "shortDescription": "$DESCRIPTION",
    "category": "Development",
    "capabilities": ["Read"]
  }
}
EOF

cat > "$TARGET_DIR/hooks/hooks.json" <<'EOF'
{
  "hooks": {}
}
EOF

cat > "$TARGET_DIR/README.md" <<EOF
# $PLUGIN_NAME

$DESCRIPTION

## Install

\`\`\`bash
codex plugin marketplace add <owner>/$PLUGIN_NAME
\`\`\`

## License

MIT
EOF

echo "OK: scaffolded $PLUGIN_NAME at $TARGET_DIR"
echo ""
echo "Structure:"
find "$TARGET_DIR" -not -path '*/\.*' -not -name '.DS_Store' | head -20
