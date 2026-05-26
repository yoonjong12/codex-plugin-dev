# SKILL.md Frontmatter Specification

## Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Skill identifier (kebab-case) |
| `description` | string | Trigger description — determines when the skill is loaded |

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
