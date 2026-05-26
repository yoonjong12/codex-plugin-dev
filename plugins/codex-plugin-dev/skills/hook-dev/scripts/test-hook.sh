#!/usr/bin/env bash
set -euo pipefail

HOOK_SCRIPT="${1:?Usage: test-hook.sh <hook-script> <json-input>}"
JSON_INPUT="${2:?Provide JSON input as second argument}"

if [ ! -f "$HOOK_SCRIPT" ]; then
  echo "FAIL: $HOOK_SCRIPT not found"
  exit 1
fi

if [ ! -x "$HOOK_SCRIPT" ]; then
  echo "WARN: $HOOK_SCRIPT is not executable, attempting anyway..."
fi

echo "Testing: $HOOK_SCRIPT"
echo "Input:   $JSON_INPUT"
echo ""

OUTPUT=$(echo "$JSON_INPUT" | bash "$HOOK_SCRIPT" 2>&1) || {
  echo "FAIL: hook exited with non-zero status"
  echo "Output: $OUTPUT"
  exit 1
}

echo "Output: $OUTPUT"

if echo "$OUTPUT" | python3 -c "import json,sys; json.load(sys.stdin)" 2>/dev/null; then
  echo "OK: output is valid JSON"
else
  echo "WARN: output is not valid JSON (hook may be no-op)"
fi
