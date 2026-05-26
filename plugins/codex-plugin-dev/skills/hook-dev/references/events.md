# Codex Hook Events Reference

## Common Input Fields

All hook events receive JSON on stdin with these common fields:

```json
{
  "hook_event_name": "<EventName>",
  "cwd": "/current/working/directory",
  "model": "gpt-5.4",
  "permission_mode": "default",
  "session_id": "uuid",
  "transcript_path": "/path/to/transcript.jsonl",
  "turn_id": "uuid"
}
```

## Common Output Fields

All hooks can return:

```json
{
  "decision": "approve|block",
  "reason": "Human-readable explanation",
  "continue": false,
  "suppressOutput": false,
  "systemMessage": "Optional message injected into context",
  "hookSpecificOutput": { ... }
}
```

- `decision`: `"approve"` (allow) or `"block"` (prevent)
- `continue`: boolean, force another turn after Stop
- `hookSpecificOutput`: event-specific fields (see below)

## Turn-Scoped Events

### PreToolUse

Fires before a tool executes. Can approve, block, or rewrite the tool call.

**Matcher**: tool name (e.g., `"shell"`, `"*"` for all)

**Additional input fields**:
```json
{
  "tool_name": "shell",
  "tool_input": { "command": "..." },
  "tool_use_id": "uuid"
}
```

**hookSpecificOutput**:
```json
{
  "hookSpecificOutput": {
    "permissionDecision": "allow|deny|ask",
    "updatedInput": { "command": "..." },
    "additionalContext": "Extra context for the model"
  }
}
```

- `permissionDecision`: `"allow"` (auto-approve), `"deny"` (auto-deny), `"ask"` (prompt user)
- `updatedInput`: rewrite the tool input
- `additionalContext`: inject context the model sees

### PostToolUse

Fires after a tool executes. Can modify the result.

**Matcher**: tool name

**Additional input fields**:
```json
{
  "tool_name": "shell",
  "tool_input": { "command": "..." },
  "tool_output": "...",
  "tool_use_id": "uuid"
}
```

**hookSpecificOutput**:
```json
{
  "hookSpecificOutput": {
    "updatedOutput": "replacement output"
  }
}
```

### UserPromptSubmit

Fires when a user submits a prompt, before it enters the agent loop.

**Additional input fields**:
```json
{
  "prompt": "user input text"
}
```

### Stop

Fires after the agent completes a turn.

**Output**: set `"continue": true` to force another turn.

### PreCompact / PostCompact

Fires before/after conversation compression.

### PermissionRequest

Fires when the agent requests permission for a tool call.

**Additional input fields**:
```json
{
  "tool_name": "shell",
  "tool_input": { "command": "..." }
}
```

**hookSpecificOutput**:
```json
{
  "hookSpecificOutput": {
    "permissionDecision": "allow|deny|ask"
  }
}
```

## Session-Scoped Events

### SessionStart

Fires on session start, resume, clear, or compact recovery.

### SubagentStart / SubagentStop

Fires when a subagent is spawned or completes.

## Environment Variables

Hook scripts have access to:
- `PLUGIN_ROOT` / `CLAUDE_PLUGIN_ROOT` — plugin installation directory
- `PLUGIN_DATA` / `CLAUDE_PLUGIN_DATA` — writable data directory
