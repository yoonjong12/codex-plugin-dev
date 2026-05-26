---
name: hook-dev
description: Develop Codex CLI hooks. Use when the user says "create a hook", "add a hook", "write a hook", "hook development", or needs guidance on hooks.json format, available events, hook scripts, testing, or debugging hooks.
---

# Hook Development

## Overview

Hooks inject custom logic into the Codex agent loop at specific lifecycle events. They execute shell scripts and can modify, block, or augment agent behavior.

## hooks.json Structure

Place at plugin root as `hooks.json` (or `~/.codex/hooks.json` for personal hooks).

```json
{
  "hooks": {
    "<EventName>": [
      {
        "matcher": "<ToolName or pattern>",
        "hooks": [
          {
            "type": "command",
            "command": "bash ${PLUGIN_ROOT}/hooks/my-script.sh",
            "statusMessage": "Running validation...",
            "timeout": 600
          }
        ]
      }
    ]
  }
}
```

## Available Events

See `references/events.md` for the complete event list with input/output schemas.

Core events:
- **PreToolUse** — before a tool executes (can block or rewrite)
- **PostToolUse** — after a tool executes (can modify result)
- **UserPromptSubmit** — before user prompt enters the agent loop
- **SessionStart** — on session start, resume, clear, or compact
- **Stop** — after turn completion (can force continue)
- **SubagentStart / SubagentStop** — subagent lifecycle

## Hook Script Contract

Hook scripts receive JSON on stdin and must output JSON on stdout.

**Input** (from Codex):
```json
{
  "hook_event_name": "PreToolUse",
  "tool_name": "shell",
  "tool_input": { "command": "rm -rf /" },
  "cwd": "/path/to/project",
  "model": "gpt-5.4",
  "session_id": "uuid",
  "turn_id": "uuid"
}
```

**Output** (to Codex):
```json
{
  "decision": "block",
  "reason": "Destructive command blocked",
  "hookSpecificOutput": {
    "permissionDecision": "deny"
  }
}
```

Decision values: `"approve"` or `"block"`. Use `hookSpecificOutput.permissionDecision` for `"allow"`, `"deny"`, or `"ask"` (prompt user).

## Creating a Hook

1. Write the script in `scripts/` or `skills/<skill>/scripts/`
2. Make it executable: `chmod +x`
3. Register in `hooks.json` at plugin root
4. Test with the linter and test scripts

```bash
bash "${PLUGIN_ROOT}/skills/hook-dev/scripts/hook-linter.sh" hooks.json
bash "${PLUGIN_ROOT}/skills/hook-dev/scripts/test-hook.sh" scripts/my-hook.sh '{"hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"echo hello"}}'
```

## Trust Model

Codex uses hash-based trust for hooks. When a hook script changes, Codex prompts for re-approval. This is automatic — no action needed from the developer.
