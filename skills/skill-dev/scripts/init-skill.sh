#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="${1:?Usage: init-skill.sh <skill-name> [plugin-dir]}"
PLUGIN_DIR="${2:-.}"
SKILL_DIR="$PLUGIN_DIR/skills/$SKILL_NAME"

if [ -d "$SKILL_DIR" ]; then
  echo "ERROR: $SKILL_DIR already exists"
  exit 1
fi

mkdir -p "$SKILL_DIR"/{scripts,references}

cat > "$SKILL_DIR/SKILL.md" <<EOF
---
name: $SKILL_NAME
description: TODO — describe when this skill should be triggered and what it does.
---

# $SKILL_NAME

## When to Use

Describe the trigger conditions for this skill.

## Steps

1. Step one
2. Step two
3. Step three

## Output

Describe what the user should see when this skill completes.
EOF

echo "OK: created skill '$SKILL_NAME' at $SKILL_DIR"
echo ""
echo "Files:"
find "$SKILL_DIR" -type f
echo ""
echo "Next: edit $SKILL_DIR/SKILL.md to add instructions."
