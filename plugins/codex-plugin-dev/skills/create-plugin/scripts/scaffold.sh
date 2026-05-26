#!/usr/bin/env bash
set -euo pipefail

PLUGIN_NAME="${1:?Usage: scaffold.sh <plugin-name> [description]}"
DESCRIPTION="${2:-A Codex CLI plugin}"
TARGET_DIR="${3:-./$PLUGIN_NAME}"

PLUGIN_SUBDIR="$TARGET_DIR/plugins/$PLUGIN_NAME"

if [ -d "$PLUGIN_SUBDIR/.codex-plugin" ]; then
  echo "ERROR: $PLUGIN_SUBDIR/.codex-plugin already exists"
  exit 1
fi

mkdir -p "$PLUGIN_SUBDIR"/{.codex-plugin,skills,assets}
mkdir -p "$TARGET_DIR/.agents/plugins"

cat > "$PLUGIN_SUBDIR/.codex-plugin/plugin.json" <<EOF
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
  "hooks": "./hooks.json",
  "interface": {
    "displayName": "$PLUGIN_NAME",
    "shortDescription": "$DESCRIPTION",
    "category": "Development",
    "capabilities": ["Read"]
  }
}
EOF

cat > "$PLUGIN_SUBDIR/hooks.json" <<'EOF'
{
  "hooks": {}
}
EOF

cat > "$TARGET_DIR/.agents/plugins/marketplace.json" <<EOF
{
  "name": "$PLUGIN_NAME",
  "interface": {
    "displayName": "$PLUGIN_NAME"
  },
  "plugins": [
    {
      "name": "$PLUGIN_NAME",
      "source": {
        "source": "local",
        "path": "./plugins/$PLUGIN_NAME"
      },
      "policy": {
        "installation": "AVAILABLE"
      },
      "category": "Development"
    }
  ]
}
EOF

cat > "$TARGET_DIR/README.md" <<EOF
# $PLUGIN_NAME

$DESCRIPTION

## Install

\`\`\`bash
codex plugin marketplace add <owner>/$PLUGIN_NAME
codex plugin add $PLUGIN_NAME@$PLUGIN_NAME
\`\`\`

## License

MIT
EOF

echo "OK: scaffolded $PLUGIN_NAME at $TARGET_DIR"
echo ""
echo "Structure:"
find "$TARGET_DIR" -not -path '*/\.*' -not -name '.DS_Store' | head -25
