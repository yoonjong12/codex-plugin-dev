---
name: optimize-skills
description: Reduce token footprint of plugin skills by extracting boilerplate into scripts. Use when the user says "optimize plugin tokens", "scriptify skills", "reduce LLM overhead", "optimize token usage", or wants to move repetitive state management / path resolution out of SKILL.md into shell scripts.
---

# Optimize Skills

Extract repetitive boilerplate from SKILL.md files into scripts. After optimization, the LLM handles content generation only — scripts handle state transitions, file I/O, and path resolution.

## Step 1: Analyze

```bash
bash "${PLUGIN_ROOT}/skills/optimize-skills/scripts/analyze-skills.sh" "<plugin-dir>"
```

Outputs a triage table: each skill labeled as `hybrid`, `state-machine`, `content-core`, or `guidance`.

## Step 2: Filter with user

Present the triage table. Confirm target list before proceeding.

| Category | Optimize? |
|----------|-----------|
| `state-machine` | YES — routing / dispatch logic, all scriptable |
| `hybrid` | YES — scripts handle boilerplate, LLM handles content |
| `content-core` | NO — text generation is the primary job |
| `guidance` | NO — methodology docs, no mechanical parts |

See `references/triage-criteria.md` for the decision tree.

## Step 3: Extract scripts

For each target skill, extract patterns found by the analyzer.
See `references/scriptable-patterns.md` for exact patterns and script templates.

Common extractions:

| Pattern | Extract to |
|---------|-----------|
| Workspace detection `while` loop | `scripts/find-workspace.sh` |
| `json.load` / `json.dump` on state file | `scripts/update-state.sh <key> <value>` |
| STATUS line update in tracking file | `scripts/update-task-status.sh <id> <status>` |
| Skeleton file creation (structural only) | `scripts/<skill>-skeleton.sh` |

## Step 4: Rewrite SKILL.md

Replace each extracted block with a single script invocation. The rewritten body instructs the LLM to:

1. Run the script
2. Use output as context
3. Generate content-only output (no boilerplate)

Target SKILL.md length after optimization: ≤ 50% of original.

## Step 5: Verify

```bash
bash "${PLUGIN_ROOT}/skills/optimize-skills/scripts/analyze-skills.sh" "<plugin-dir>"
```

Re-run — target skills must show no remaining scriptable patterns.
Then run `codex-plugin-dev:validate` to confirm plugin structure is intact.
