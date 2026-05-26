# SKILL.md Frontmatter Specification

## Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Skill identifier (kebab-case) |
| `description` | string | Trigger description — determines when the skill is loaded |

## Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `license` | string | SPDX license identifier |
| `allowed-tools` | string[] | Tools auto-approved when this skill is active |
| `metadata` | object | Arbitrary key-value metadata |
| `disable-model-invocation` | boolean | Prevent model from auto-invoking this skill |
| `user-invocable` | boolean | Whether users can invoke directly (default: true) |
| `context` | string | `"fork"` to run in a subagent context |
| `agent` | string | Agent name to delegate to when `context: fork` |

## Description Best Practices

The description is the primary matching mechanism. Codex loads name + description at session start and matches against user input.

Good description:
```yaml
description: Create and develop Codex CLI skills. Use when the user says "create a skill", "add a skill", "new skill", or needs guidance on SKILL.md structure.
```

Bad description:
```yaml
description: A skill for skills.
```

### Guidelines

- Include 3-5 trigger phrases that users would naturally say
- Mention the domain explicitly
- Stay under 8,000 characters (Codex enforces ~2% of context window)
- Front-load the most important keywords
