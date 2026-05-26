#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="${1:?Usage: validate-plugin.sh <plugin-dir>}"
ERRORS=0
WARNINGS=0

ok()   { echo "  OK: $1"; }
warn() { echo "  WARN: $1"; WARNINGS=$((WARNINGS + 1)); }
fail() { echo "  FAIL: $1"; ERRORS=$((ERRORS + 1)); }

echo "=== Validating plugin at: $PLUGIN_DIR ==="
echo ""

# --- Manifest ---
echo "[Manifest]"
MANIFEST="$PLUGIN_DIR/.codex-plugin/plugin.json"
if [ ! -f "$MANIFEST" ]; then
  fail ".codex-plugin/plugin.json not found"
else
  ok "plugin.json exists"

  NAME=$(python3 -c "import json; print(json.load(open('$MANIFEST')).get('name',''))" 2>/dev/null || true)
  VERSION=$(python3 -c "import json; print(json.load(open('$MANIFEST')).get('version',''))" 2>/dev/null || true)
  DESC=$(python3 -c "import json; print(json.load(open('$MANIFEST')).get('description',''))" 2>/dev/null || true)

  [ -n "$NAME" ]    && ok "name: $NAME"       || fail "missing 'name' field"
  [ -n "$VERSION" ] && ok "version: $VERSION"  || fail "missing 'version' field"
  [ -n "$DESC" ]    && ok "description present" || fail "missing 'description' field"

  if echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    ok "version is valid semver"
  else
    warn "version '$VERSION' may not be valid semver"
  fi
fi
echo ""

# --- Skills ---
echo "[Skills]"
SKILLS_DIR="$PLUGIN_DIR/skills"
if [ ! -d "$SKILLS_DIR" ]; then
  warn "no skills/ directory"
else
  SKILL_COUNT=0
  for skill_dir in "$SKILLS_DIR"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name=$(basename "$skill_dir")
    SKILL_MD="$skill_dir/SKILL.md"

    if [ ! -f "$SKILL_MD" ]; then
      fail "skills/$skill_name: missing SKILL.md"
    else
      SKILL_COUNT=$((SKILL_COUNT + 1))

      if head -1 "$SKILL_MD" | grep -q '^---$'; then
        ok "skills/$skill_name: has frontmatter"
      else
        fail "skills/$skill_name: SKILL.md missing YAML frontmatter"
      fi

      if grep -q '^name:' "$SKILL_MD"; then
        ok "skills/$skill_name: has name field"
      else
        fail "skills/$skill_name: missing name in frontmatter"
      fi

      if grep -q '^description:' "$SKILL_MD"; then
        ok "skills/$skill_name: has description field"
      else
        fail "skills/$skill_name: missing description in frontmatter"
      fi
    fi
  done
  [ "$SKILL_COUNT" -gt 0 ] && ok "$SKILL_COUNT skill(s) found" || warn "no skills found"
fi
echo ""

# --- Hooks ---
echo "[Hooks]"
HOOKS_FILE="$PLUGIN_DIR/hooks.json"
if [ ! -f "$HOOKS_FILE" ]; then
  warn "no hooks.json at plugin root (optional)"
else
  if python3 -c "import json; json.load(open('$HOOKS_FILE'))" 2>/dev/null; then
    ok "hooks.json is valid JSON"
  else
    fail "hooks.json is invalid JSON"
  fi
fi
echo ""

# --- Marketplace ---
echo "[Marketplace]"
REPO_ROOT="$(dirname "$(dirname "$PLUGIN_DIR")")"
MKT_FILE="$REPO_ROOT/.agents/plugins/marketplace.json"
if [ ! -f "$MKT_FILE" ]; then
  warn "no .agents/plugins/marketplace.json at repo root (required for 'codex plugin marketplace add')"
else
  if python3 -c "import json; json.load(open('$MKT_FILE'))" 2>/dev/null; then
    ok "marketplace.json is valid JSON"
  else
    fail "marketplace.json is invalid JSON"
  fi
fi
echo ""

# --- MCP ---
echo "[MCP]"
MCP_FILE="$PLUGIN_DIR/.mcp.json"
if [ ! -f "$MCP_FILE" ]; then
  warn "no .mcp.json (optional)"
else
  if python3 -c "import json; json.load(open('$MCP_FILE'))" 2>/dev/null; then
    ok ".mcp.json is valid JSON"
  else
    fail ".mcp.json is invalid JSON"
  fi
fi
echo ""

# --- Scripts executable ---
echo "[Scripts]"
SCRIPT_COUNT=0
while IFS= read -r -d '' script; do
  SCRIPT_COUNT=$((SCRIPT_COUNT + 1))
  if [ -x "$script" ]; then
    ok "$(echo "$script" | sed "s|$PLUGIN_DIR/||"): executable"
  else
    warn "$(echo "$script" | sed "s|$PLUGIN_DIR/||"): not executable"
  fi
done < <(find "$PLUGIN_DIR" -name '*.sh' -print0 2>/dev/null)
[ "$SCRIPT_COUNT" -eq 0 ] && warn "no shell scripts found"
echo ""

# --- Summary ---
echo "=== Summary ==="
echo "  Errors:   $ERRORS"
echo "  Warnings: $WARNINGS"
if [ "$ERRORS" -eq 0 ]; then
  echo "  Status:   PASS"
  exit 0
else
  echo "  Status:   FAIL"
  exit 1
fi
