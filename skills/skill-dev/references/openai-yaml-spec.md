# openai.yaml Specification

Optional metadata file placed at `skills/<skill-name>/agents/openai.yaml`.

## Interface Section

Controls how the skill appears in Codex App and IDE integrations.

```yaml
interface:
  display_name: "User-Facing Skill Name"
  short_description: "Brief one-liner for listings"
  icon_small: "./assets/icon-sm.png"
  icon_large: "./assets/icon-lg.png"
  brand_color: "#3B82F6"
  default_prompt: "Surrounding context or example prompt"
```

## Policy Section

Controls invocation behavior.

```yaml
policy:
  allow_implicit_invocation: true   # default: true
```

When `false`, the skill is only loaded when explicitly requested by name. Useful for destructive or expensive skills.

## Dependencies Section

Declare external tool requirements.

```yaml
dependencies:
  tools:
    - type: "mcp"
      value: "github-server"
      description: "GitHub API access for PR operations"
    - type: "mcp"
      value: "jira-server"
      description: "Jira API for issue tracking"
```

Codex uses this to warn users if required MCP servers are not configured.
