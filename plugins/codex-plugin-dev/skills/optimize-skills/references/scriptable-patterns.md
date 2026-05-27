# Scriptable Patterns & Templates

## Pattern 1: Workspace Detection Loop

**Detected by**: `while [ "$DIR" != "/" ]` in SKILL.md

**Current inline form** (extract this):
```bash
DIR="$(pwd)"; WS=""
while [ "$DIR" != "/" ]; do
  [ -f "$DIR/.humanpowers/state.json" ] && WS="$DIR" && break
  DIR="$(dirname "$DIR")"
done
[ -z "$WS" ] && { echo "no workspace found"; exit 1; }
```

**Script template** (`scripts/find-workspace.sh`):
```bash
#!/usr/bin/env bash
# find-workspace.sh [state-file-name]
# Walks up from cwd to find workspace root. Outputs: WS=<path> PHASE=<phase>
STATE_FILE="${1:-.humanpowers/state.json}"
DIR="$(pwd)"; WS=""
while [ "$DIR" != "/" ]; do
  [ -f "$DIR/$STATE_FILE" ] && WS="$DIR" && break
  DIR="$(dirname "$DIR")"
done
[ -z "$WS" ] && { echo "ERROR: no workspace found (looked for $STATE_FILE)" >&2; exit 1; }
PHASE=$(python3 -c "import json,sys; print(json.load(open('$WS/$STATE_FILE')).get('phase','unknown'))" 2>/dev/null || echo "unknown")
echo "WS=$WS"
echo "PHASE=$PHASE"
```

**Replacement in SKILL.md**:
```
eval "$(bash "$PLUGIN_ROOT/scripts/find-workspace.sh")"
# WS and PHASE now available as shell variables
```

---

## Pattern 2: State JSON Write

**Detected by**: `json.dump`, `json.load`, inline Python opening state.json for write

**Current inline form** (extract this):
```python
import json
with open(f'{WS}/.humanpowers/state.json') as f:
    s = json.load(f)
s['tasks_quiz_done'] = 7
with open(f'{WS}/.humanpowers/state.json', 'w') as f:
    json.dump(s, f, indent=2)
```

**Script template** (`scripts/update-state.sh`):
```bash
#!/usr/bin/env bash
# update-state.sh <workspace> <key> <value>
WS="$1"; KEY="$2"; VALUE="$3"
STATE="$WS/.humanpowers/state.json"
python3 - <<EOF
import json
with open('$STATE') as f: s = json.load(f)
s['$KEY'] = '$VALUE'
with open('$STATE', 'w') as f: json.dump(s, f, indent=2)
print(json.dumps(s, indent=2))
EOF
```

**Replacement in SKILL.md**:
```
bash "$PLUGIN_ROOT/scripts/update-state.sh" "$WS" tasks_quiz_done 7
```

---

## Pattern 3: STATUS Line Update in Tracking File

**Detected by**: inline sed or Edit tool targeting `**STATUS**:` line in tasks.md

**Script template** (`scripts/update-task-status.sh`):
```bash
#!/usr/bin/env bash
# update-task-status.sh <workspace> <task-id> <new-status>
WS="$1"; TASK_ID="$2"; NEW_STATUS="$3"
TASKS="$WS/.humanpowers/tasks.md"
# Replace the LAST **STATUS**: line within the task's section
python3 - <<'EOF'
import re, sys
ws, tid, status = sys.argv[1], sys.argv[2], sys.argv[3]
path = f"{ws}/.humanpowers/tasks.md"
with open(path) as f: content = f.read()
# Find task section and update its last STATUS line
pattern = rf'(### Task {re.escape(tid)}.*?)(\*\*STATUS\*\*: )\w[\w-]*'
result = re.sub(pattern, rf'\1\g<2>{status}', content, count=1, flags=re.DOTALL)
with open(path, 'w') as f: f.write(result)
print(f"Task {tid} → {status}")
EOF
python3 - "$WS" "$TASK_ID" "$NEW_STATUS"
```

**Replacement in SKILL.md**:
```
bash "$PLUGIN_ROOT/scripts/update-task-status.sh" "$WS" "$TASK_ID" quiz-done
```

---

## Pattern 4: Skeleton File Creation

**Detected by**: Write() or Wrote calls that produce structural templates (not LLM content)

**Script template** (`scripts/<skill>-skeleton.sh`):
```bash
#!/usr/bin/env bash
# <skill>-skeleton.sh <workspace> <task-id>
WS="$1"; TASK_ID="$2"
OUT="$WS/.humanpowers/tasks/$TASK_ID/round1.md"
mkdir -p "$(dirname "$OUT")"
cat > "$OUT" <<'TEMPLATE'
# task-{TASK_ID} round1.md

## Activation Log

| Dimension | Active? | Reason | Fork | Qs |
|-----------|---------|--------|------|----|
| Intent    | [FILL]  | [FILL] | —    | 0  |
| Observable| [FILL]  | [FILL] | —    | 0  |
| Acceptance| [FILL]  | [FILL] | —    | 0  |
| Constraint| [FILL]  | [FILL] | —    | 0  |
| Scope     | [FILL]  | [FILL] | —    | 0  |
| Risk      | [FILL]  | [FILL] | —    | 0  |
| Dependency| [FILL]  | [FILL] | —    | 0  |
| Edge      | [FILL]  | [FILL] | —    | 0  |
| Done      | [FILL]  | [FILL] | —    | 0  |
TEMPLATE
sed -i "s/{TASK_ID}/$TASK_ID/g" "$OUT"
echo "Skeleton created: $OUT"
```

**Replacement in SKILL.md**:
```
bash "$PLUGIN_ROOT/scripts/quiz-skeleton.sh" "$WS" "$TASK_ID"
# LLM fills only the [FILL] cells
```

---

## Workspace Summary (bonus)

Add `scripts/workspace-summary.sh` to replace multi-file reads for status queries:

```bash
#!/usr/bin/env bash
# workspace-summary.sh <workspace>
WS="$1"
python3 - <<EOF
import json, re
state = json.load(open('$WS/.humanpowers/state.json'))
tasks_md = open('$WS/.humanpowers/tasks.md').read() if __import__('os').path.exists('$WS/.humanpowers/tasks.md') else ''
statuses = re.findall(r'\*\*STATUS\*\*: (\S+)', tasks_md)
from collections import Counter
counts = Counter(statuses)
print(f"Phase: {state.get('phase','?')}")
print(f"Tasks: {state.get('tasks_total','?')} total")
for s, c in counts.items():
    print(f"  {s}: {c}")
pending = [re.search(r'id: (\S+)', b).group(1) for b in re.split(r'(?=### Task)', tasks_md) if re.search(r'\*\*STATUS\*\*: (?!verified|finished)', b) and re.search(r'id: \S+', b)]
if pending: print(f"Pending: {', '.join(pending)}")
EOF
```
