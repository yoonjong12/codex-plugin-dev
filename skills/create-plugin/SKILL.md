---
name: create-plugin
description: Scaffold a new Codex CLI plugin from scratch. Use when the user says "create a plugin", "new plugin", "scaffold plugin", "init plugin", or describes a plugin idea they want to build. Guides through discovery, component planning, scaffolding, and initial implementation.
---

# Create Plugin

Guide the user through creating a complete Codex CLI plugin. Follow these phases sequentially.

## Phase 1: Discovery

Understand what the plugin needs to do before writing anything.

Ask the user:
1. What problem does this plugin solve?
2. Who uses it and when?
3. Any existing plugins or tools to reference?

Summarize understanding and confirm before proceeding.

## Phase 2: Component Planning

Determine which components the plugin needs. Present this checklist and ask the user to confirm:

- **Skills** — reusable task instructions (most plugins need at least one)
- **Hooks** — lifecycle event handlers (PreToolUse, PostToolUse, SessionStart, etc.)
- **Agents** — subagent definitions (.toml) for delegated tasks
- **MCP servers** — external tool integrations (.mcp.json)
- **App connectors** — external service auth (.app.json)
- **Commands** — slash commands

For each selected component, briefly describe its purpose in this plugin.

## Phase 3: Scaffold

Run the scaffold script to create the directory structure:

```bash
bash "${PLUGIN_ROOT}/skills/create-plugin/scripts/scaffold.sh" "<plugin-name>" "<description>" "<target-dir>"
```

After scaffolding, update `.codex-plugin/plugin.json` with:
- Author name and URL
- Accurate keywords
- Correct `interface.category` (Development, Productivity, Integration, Analysis, etc.)
- `interface.capabilities` matching what the plugin does

Refer to `references/manifest-spec.md` for the full plugin.json specification.

## Phase 4: Implement Skills

For each planned skill:

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`) and markdown body
2. Add `scripts/` for any shell automation the skill needs
3. Add `references/` for domain knowledge that should load on-demand
4. Optionally add `agents/openai.yaml` for UI metadata and dependency declarations

Keep each SKILL.md focused on one task. Use imperative steps. Include explicit input/output expectations.

## Phase 5: Implement Other Components

For hooks: create `hooks/hooks.json` with event handlers. Use `"type": "command"` handlers pointing to scripts.

For agents: create `.toml` files in `agents/` with `name`, `description`, `developer_instructions` fields.

For MCP: create `.mcp.json` at plugin root with server definitions.

## Phase 6: Validate

Run the validation script:

```bash
bash "${PLUGIN_ROOT}/skills/validate/scripts/validate-plugin.sh" "<plugin-dir>"
```

Fix any reported issues before proceeding.

## Phase 7: Summary

Report to the user:
- Components created (count of skills, hooks, agents, MCP servers)
- Next steps (test locally, publish to marketplace)
- Any manual steps remaining (author info, API keys, etc.)
