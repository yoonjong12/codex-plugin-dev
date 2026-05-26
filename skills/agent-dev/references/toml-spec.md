# Codex Agent TOML Specification

## Required Fields

```toml
name = "agent-name"                    # kebab-case identifier
description = "When and why to use"    # used for agent selection
developer_instructions = """           # multi-line system prompt
Behavioral guidance goes here.
"""
```

## Optional Fields

```toml
model = "gpt-5.4"                     # override default model
model_reasoning_effort = "high"        # reasoning intensity
sandbox_mode = "read-only"             # "read-only" | "workspace-write" | "danger-full-access"
nickname_candidates = ["Alias1"]       # display names in UI
```

## MCP Server Binding

```toml
[mcp_servers.server_name]
url = "stdio://command"                # or "https://..." for SSE/HTTP
```

## Skill Configuration

```toml
[skills.config]
disabled = ["skill-to-exclude"]        # prevent loading specific skills
```

## File Location

| Scope | Path |
|-------|------|
| Personal | `~/.codex/agents/<name>.toml` |
| Project | `.codex/agents/<name>.toml` |

Note: agents cannot be bundled inside plugins. They must be installed at personal or project scope.

## Built-in Agents

Codex provides three built-in agents: `default`, `worker`, `explorer`. Custom agents extend this set.

## Orchestration Limits

Configured in `config.toml`:
```toml
[agents]
max_threads = 6
max_depth = 1
```
