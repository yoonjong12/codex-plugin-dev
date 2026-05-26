#!/usr/bin/env bash
set -euo pipefail

BUMP_TYPE="${1:?Usage: publish.sh <major|minor|patch> [plugin-dir]}"
PLUGIN_DIR="${2:-.}"
MANIFEST="$PLUGIN_DIR/.codex-plugin/plugin.json"

if [ ! -f "$MANIFEST" ]; then
  echo "FAIL: $MANIFEST not found"
  exit 1
fi

case "$BUMP_TYPE" in
  major|minor|patch) ;;
  *) echo "FAIL: bump type must be major, minor, or patch"; exit 1 ;;
esac

CURRENT=$(python3 -c "import json; print(json.load(open('$MANIFEST'))['version'])")
echo "Current version: $CURRENT"

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"
case "$BUMP_TYPE" in
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  patch) PATCH=$((PATCH + 1)) ;;
esac
NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "New version:     $NEW_VERSION"

python3 -c "
import json
with open('$MANIFEST', 'r') as f:
    data = json.load(f)
data['version'] = '$NEW_VERSION'
with open('$MANIFEST', 'w') as f:
    json.dump(data, f, indent=2)
    f.write('\n')
"
echo "OK: updated $MANIFEST"

cd "$PLUGIN_DIR"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "WARN: not a git repo — skipping git operations"
  echo "Done. Version bumped to $NEW_VERSION (local only)."
  exit 0
fi

if [ -n "$(git status --porcelain)" ]; then
  git add -A
  git commit -m "release: v$NEW_VERSION"
  echo "OK: committed"
fi

git tag -a "v$NEW_VERSION" -m "v$NEW_VERSION"
echo "OK: tagged v$NEW_VERSION"

if git remote get-url origin >/dev/null 2>&1; then
  echo ""
  echo "Ready to push. Run:"
  echo "  git push origin main --tags"
  echo ""
  echo "Then register in Codex:"
  echo "  codex plugin marketplace add $(git remote get-url origin | sed 's/.*github.com[:/]//' | sed 's/.git$//')"
else
  echo "WARN: no git remote — push manually"
fi

echo ""
echo "Published: v$NEW_VERSION"
