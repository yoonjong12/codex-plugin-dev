# Codex Hook Events Reference

## Turn-Scoped Events

### PreToolUse

Fires before a tool executes. Can approve, deny, or rewrite the tool call.

**Matcher**: tool name (e.g., `"Bash"`, `"Write"`, `"*"` for all)

**Input**: `{ "hook_event": "PreToolUse", "tool_name": "...", "tool_input": {...} }`

**Output**: `{ "decision": "approve|deny|skip", "reason": "..." }` or `{ "tool_input": {...} }` to rewrite

### PostToolUse

Fires after a tool executes. Can modify the result.

**Matcher**: tool name

**Input**: `{ "hook_event": "PostToolUse", "tool_name": "...", "tool_input": {...}, "tool_output": "..." }`

**Output**: `{ "tool_output": "..." }` to replace result, or empty for no-op

### UserPromptSubmit

Fires when a user submits a prompt, before it enters the agent loop.

**Matcher**: none (fires for all prompts)

**Input**: `{ "hook_event": "UserPromptSubmit", "prompt": "..." }`

**Output**: `{ "prompt": "..." }` to rewrite, or empty for no-op

### Stop

Fires after the agent completes a turn. Can force continuation.

**Input**: `{ "hook_event": "Stop", "stop_reason": "..." }`

**Output**: `{ "decision": "continue", "reason": "..." }` to force another turn

### PreCompact / PostCompact

Fires before/after conversation compression.

### PermissionRequest

Fires when the agent requests permission for a tool call. Can auto-approve or auto-deny.

**Input**: `{ "hook_event": "PermissionRequest", "tool_name": "...", "tool_input": {...} }`

**Output**: `{ "decision": "approve|deny" }`

## Session-Scoped Events

### SessionStart

Fires on session start, resume, clear, or compact recovery.

**Input**: `{ "hook_event": "SessionStart", "trigger": "start|resume|clear|compact" }`

### SubagentStart / SubagentStop

Fires when a subagent is spawned or completes.

## Environment Variables

Hook scripts have access to:
- `PLUGIN_ROOT` / `CLAUDE_PLUGIN_ROOT` — plugin installation directory
- `PLUGIN_DATA` / `CLAUDE_PLUGIN_DATA` — writable data directory
