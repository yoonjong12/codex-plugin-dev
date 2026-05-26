# Codex Internal Test Plan

## Prerequisites

- Codex CLI installed (`which codex`)
- GitHub repo pushed (`yoonjong12/codex-plugin-dev`)

## Test Matrix

### T1: Plugin Installation

```bash
codex plugin marketplace add yoonjong12/codex-plugin-dev
```

Expected: plugin appears in `/plugins` list with 7 skills.

### T2: create-plugin Skill

In Codex, say: "Create a plugin called test-plugin that does code formatting"

Verify:
- [ ] Codex loads `create-plugin` skill
- [ ] Asks discovery questions (purpose, components)
- [ ] Runs `scaffold.sh` to create directory structure
- [ ] Generated `plugin.json` has correct fields
- [ ] Directory structure matches spec

### T3: skill-dev Skill

In Codex, say: "Add a new skill called format-check to test-plugin"

Verify:
- [ ] Runs `init-skill.sh`
- [ ] Creates `skills/format-check/SKILL.md` with frontmatter template
- [ ] Creates `scripts/` and `references/` subdirectories

### T4: validate Skill

In Codex, say: "Validate test-plugin"

Verify:
- [ ] Runs `validate-plugin.sh`
- [ ] Reports correct pass/fail/warn counts
- [ ] Catches intentionally broken manifest (rename `name` field to test)

### T5: hook-dev Skill

In Codex, say: "Create a PreToolUse hook for test-plugin that blocks rm -rf"

Verify:
- [ ] Generates `hooks/hooks.json` with PreToolUse entry
- [ ] Creates hook script
- [ ] `hook-linter.sh` passes on generated hooks.json

### T6: agent-dev Skill

In Codex, say: "Create a code-reviewer agent for test-plugin"

Verify:
- [ ] Runs `init-agent.sh`
- [ ] Creates `agents/code-reviewer.toml` with required fields
- [ ] Fields are valid per toml-spec.md

### T7: mcp-dev Skill

In Codex, say: "Add a GitHub MCP server to test-plugin"

Verify:
- [ ] Creates `.mcp.json` at plugin root
- [ ] Uses environment variable for auth (no hardcoded secrets)
- [ ] Updates `plugin.json` mcpServers pointer

### T8: publish Skill

In Codex, say: "Publish test-plugin as patch release"

Verify:
- [ ] Validates before publishing
- [ ] Bumps version in plugin.json (0.1.0 → 0.1.1)
- [ ] Creates git commit and tag
- [ ] Prints correct push/registration commands

### T9: plugin-reviewer Agent

In Codex, say: "Review test-plugin for quality"

Verify:
- [ ] Codex spawns plugin-reviewer subagent
- [ ] Reviews all components (manifest, skills, hooks, agents)
- [ ] Reports PASS/IMPROVE/FAIL per component
- [ ] Provides actionable summary

## Regression Checks

After each test:
- [ ] No errors in Codex console
- [ ] Skill loaded via progressive disclosure (not always in context)
- [ ] Shell commands executed in sandbox without permission issues
- [ ] Scripts reference `${PLUGIN_ROOT}` correctly

## Known Limitations to Document

- No `AskUserQuestion` — confirm Codex handles conversational prompts gracefully
- No `Skill` chaining — confirm create-plugin workflow completes within single skill context
- Shell-only file operations — confirm file creation accuracy
