# Codex Plugin Manifest Specification

## File Location

`.codex-plugin/plugin.json` at the plugin root directory.

## Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Plugin identifier (kebab-case, lowercase) |
| `version` | string | Semver version (e.g., "1.0.0") |
| `description` | string | One-line description of what the plugin does |

## Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `author.name` | string | Publisher name |
| `author.email` | string | Contact email |
| `author.url` | string | Publisher URL |
| `homepage` | string | Plugin homepage URL |
| `repository` | string | Source repository URL |
| `license` | string | SPDX license identifier |
| `keywords` | string[] | Discovery keywords |
| `skills` | string | Path to skills directory (default: `"./skills/"`) |
| `mcpServers` | string | Path to MCP config (default: `"./.mcp.json"`) |
| `apps` | string | Path to app connector config (default: `"./.app.json"`) |
| `hooks` | string | Path to hooks config (default: `"./hooks/hooks.json"`) |

## Interface Block

Controls how the plugin appears in Codex App/IDE.

```json
{
  "interface": {
    "displayName": "Human-readable Plugin Name",
    "shortDescription": "Brief description for listings",
    "longDescription": "Detailed description for plugin detail page",
    "developerName": "Publisher display name",
    "category": "Development",
    "capabilities": ["Read", "Write"],
    "websiteURL": "https://example.com",
    "privacyPolicyURL": "https://example.com/privacy",
    "termsOfServiceURL": "https://example.com/terms",
    "defaultPrompt": ["Example prompt that uses this plugin."],
    "brandColor": "#10A37F",
    "composerIcon": "./assets/icon.png",
    "logo": "./assets/logo.png",
    "screenshots": ["./assets/screenshot-1.png"]
  }
}
```

### Category Values

Development, Productivity, Integration, Analysis, Security, Testing, Documentation, DevOps, Design, Communication

### Capabilities

Declare what the plugin can do: `"Read"`, `"Write"`, or both.
