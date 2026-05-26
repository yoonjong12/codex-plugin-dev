---
name: validate
description: Validate a Codex plugin's structure, manifest, skills, hooks, agents, and scripts. Use when the user says "validate plugin", "check plugin", "verify plugin structure", "is my plugin correct", or before publishing.
---

# Validate Plugin

Run comprehensive validation on a Codex plugin directory.

## Usage

```bash
bash "${PLUGIN_ROOT}/skills/validate/scripts/validate-plugin.sh" "<plugin-dir>"
```

## What It Checks

| Component | Checks |
|-----------|--------|
| Manifest | `.codex-plugin/plugin.json` exists, required fields (name, version, description), semver format |
| Skills | Each skill dir has `SKILL.md`, frontmatter contains `name` and `description` |
| Hooks | `hooks/hooks.json` is valid JSON |
| Agents | Each `.toml` file has required fields (name, description, developer_instructions) |
| MCP | `.mcp.json` is valid JSON |
| Scripts | All `.sh` files are executable |

## Interpreting Results

- **FAIL** — must fix before publishing
- **WARN** — optional component missing (safe to ignore if intentional)
- **OK** — component validates

## After Validation

If all checks pass, the plugin is ready for local testing:

```bash
codex plugin marketplace add ./path/to/plugin
```

Then invoke skills in Codex to verify runtime behavior.
