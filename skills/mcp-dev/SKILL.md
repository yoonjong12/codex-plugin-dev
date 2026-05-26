---
name: mcp-dev
description: Integrate MCP servers and app connectors into Codex plugins. Use when the user says "add MCP", "configure MCP server", "MCP integration", "add app connector", "connect external service", or needs guidance on .mcp.json or .app.json configuration.
---

# MCP Integration

## Overview

MCP (Model Context Protocol) servers provide external tools to Codex. App connectors (.app.json) handle authenticated service integrations (Gmail, Slack, GitHub, etc.).

## .mcp.json Configuration

Place at plugin root. Each key is a server name:

```json
{
  "github": {
    "command": "github-mcp-server",
    "args": ["--stdio"]
  },
  "jira": {
    "command": "npx",
    "args": ["-y", "@anthropic/jira-mcp-server"],
    "env": {
      "JIRA_URL": "https://myorg.atlassian.net"
    }
  }
}
```

## Server Types

See `references/server-types.md` for details on each transport.

| Type | Config | Use Case |
|------|--------|----------|
| stdio | `command` + `args` | Local CLI tools |
| SSE | `url` (https endpoint) | Remote servers with streaming |
| HTTP | `url` (https endpoint) | Simple request/response |

## .app.json Configuration

For authenticated external services:

```json
{
  "gmail": {
    "type": "oauth2",
    "provider": "google",
    "scopes": ["gmail.readonly"]
  }
}
```

App connectors handle OAuth flows automatically. Users grant permissions on first use.

## Adding MCP to a Plugin

1. Create `.mcp.json` at plugin root
2. Reference in `plugin.json`: `"mcpServers": "./.mcp.json"`
3. Declare dependencies in skill's `openai.yaml`:
   ```yaml
   dependencies:
     tools:
       - type: "mcp"
         value: "github"
         description: "GitHub API access"
   ```

## Diagnostics

In Codex, run `/mcp` or `/mcp verbose` to check server status.

## Best Practices

- Use `env` for configurable values (URLs, tokens) — never hardcode secrets
- Declare MCP dependencies in skill `openai.yaml` so Codex warns if servers are missing
- Prefer stdio transport for local tools (simpler, no network)
- Use SSE for remote servers that stream responses
