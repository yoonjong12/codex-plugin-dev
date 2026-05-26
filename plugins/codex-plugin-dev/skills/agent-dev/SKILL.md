---
name: agent-dev
description: Create Codex CLI subagent definitions (.toml). Use when the user says "create an agent", "add a subagent", "write agent toml", "agent development", or needs guidance on agent configuration, sandbox modes, MCP binding, or agent orchestration.
---

# Agent Development

## Overview

Codex subagents are specialized workers defined in `.toml` files. Each agent has its own system prompt, model, sandbox policy, and optional MCP server bindings.

## Agent File Location

Agents cannot be bundled inside plugins. Install at personal or project scope:

- Personal agents: `~/.codex/agents/<agent-name>.toml`
- Project agents: `.codex/agents/<agent-name>.toml`

## .toml Structure

```toml
name = "security-reviewer"
description = "Reviews code changes for security vulnerabilities, injection risks, and auth issues"
developer_instructions = """
You are a security-focused code reviewer. For every change:
1. Check for injection vulnerabilities (SQL, command, XSS)
2. Verify authentication and authorization boundaries
3. Flag hardcoded secrets or credentials
4. Report findings with severity (critical/high/medium/low)
"""
model = "gpt-5.4"
sandbox_mode = "read-only"
nickname_candidates = ["Argus", "Sentinel"]
```

## Required Fields

| Field | Description |
|-------|-------------|
| `name` | Agent identifier (kebab-case) |
| `description` | When and why to use this agent |
| `developer_instructions` | Behavioral guidance (the system prompt) |

## Optional Fields

| Field | Default | Description |
|-------|---------|-------------|
| `model` | inherits | Override model (e.g., "gpt-5.4") |
| `model_reasoning_effort` | - | Reasoning intensity |
| `sandbox_mode` | "workspace-write" | `"read-only"`, `"workspace-write"`, `"danger-full-access"` |
| `nickname_candidates` | [] | Display names for UI |

## MCP Server Binding

Bind MCP servers to specific agents:

```toml
[mcp_servers.github]
url = "https://mcp.github.com/sse"

[mcp_servers.jira]
url = "stdio://jira-mcp-server"
```

## Skill Configuration

Override skill loading for an agent:

```toml
[skills.config]
disabled = ["dangerous-skill"]
```

## Initialize an Agent

```bash
bash "${PLUGIN_ROOT}/skills/agent-dev/scripts/init-agent.sh" "<agent-name>" "<plugin-dir>"
```

## Best Practices

- Write `developer_instructions` as if briefing a new team member
- Use `sandbox_mode = "read-only"` for review/analysis agents
- Keep agents focused — one role per agent
- Bind only the MCP servers the agent actually needs
