#!/usr/bin/env bash
set -euo pipefail

HOOKS_FILE="${1:?Usage: hook-linter.sh <hooks.json>}"

if [ ! -f "$HOOKS_FILE" ]; then
  echo "FAIL: $HOOKS_FILE not found"
  exit 1
fi

echo "Linting $HOOKS_FILE..."

if ! python3 -c "import json; json.load(open('$HOOKS_FILE'))" 2>/dev/null; then
  echo "FAIL: invalid JSON"
  exit 1
fi
echo "  OK: valid JSON"

python3 -c "
import json, sys

VALID_EVENTS = {
    'PreToolUse', 'PostToolUse', 'UserPromptSubmit',
    'SessionStart', 'Stop', 'SubagentStart', 'SubagentStop',
    'PreCompact', 'PostCompact', 'PermissionRequest'
}
VALID_TYPES = {'command'}

data = json.load(open('$HOOKS_FILE'))
hooks = data.get('hooks', {})
errors = 0

for event, handlers in hooks.items():
    if event not in VALID_EVENTS:
        print(f'  WARN: unknown event \"{event}\"')
    if not isinstance(handlers, list):
        print(f'  FAIL: {event} must be an array')
        errors += 1
        continue
    for i, handler in enumerate(handlers):
        for hook in handler.get('hooks', []):
            htype = hook.get('type', '')
            if htype not in VALID_TYPES:
                print(f'  FAIL: {event}[{i}] invalid type \"{htype}\" (must be \"command\")')
                errors += 1
            if not hook.get('command'):
                print(f'  FAIL: {event}[{i}] missing command')
                errors += 1
            else:
                print(f'  OK: {event}[{i}] → {hook[\"command\"][:60]}')

if errors:
    print(f'\n{errors} error(s) found')
    sys.exit(1)
else:
    print('\nAll hooks valid')
"
