---
name: skill-dev
description: Create and develop Codex CLI skills. Use when the user says "create a skill", "add a skill", "new skill", "write a skill", or needs guidance on SKILL.md structure, frontmatter, progressive disclosure, references, scripts, or openai.yaml metadata.
---

# Skill Development

## Initialize a New Skill

Run the init script to create the skill directory structure:

```bash
bash "${PLUGIN_ROOT}/skills/skill-dev/scripts/init-skill.sh" "<skill-name>" "<plugin-dir>"
```

Then edit the generated SKILL.md.

## SKILL.md Structure

Every skill requires a SKILL.md with two parts:

### 1. YAML Frontmatter (required)

```yaml
---
name: my-skill
description: Trigger description — include key phrases users will say.
---
```

The `description` field is critical. It controls when the skill is loaded:
- Include trigger phrases ("create a", "fix the", "review this")
- Include the domain ("PR review", "database migration", "API testing")
- Keep under 8,000 characters (Codex context budget)

### 2. Markdown Body (required)

Write imperative instructions. Structure as sequential steps with clear input/output.

Effective patterns:
- Start with "When to Use" — clarify scope
- Use numbered steps for procedures
- Include shell commands the model should run
- Reference scripts in `scripts/` for complex operations
- Reference domain knowledge in `references/` for progressive disclosure

Avoid:
- Abstract explanations without actionable steps
- Overly long content (context window is shared)
- Duplicating information available in references

## Bundled Resources

### scripts/

Executable code (bash, python) for deterministic operations. Use when:
- Exact output format matters
- File system operations need to be atomic
- Validation logic is complex

### references/

Markdown files loaded on-demand. Use for:
- Specifications and schemas
- Examples and templates
- Domain knowledge that not every invocation needs

### assets/

Static files used in output: templates, icons, config files.

## openai.yaml (optional)

Add `agents/openai.yaml` inside the skill directory for Codex-specific metadata:

```yaml
interface:
  display_name: "Human-Readable Skill Name"
  short_description: "Brief description for UI"
  icon_small: "./assets/icon-sm.png"
  brand_color: "#3B82F6"
  default_prompt: "Example prompt"

policy:
  allow_implicit_invocation: true

dependencies:
  tools:
    - type: "mcp"
      value: "serverName"
      description: "What this MCP server provides"
```

See `references/openai-yaml-spec.md` for the full specification.

## Skill Search Priority

Codex loads skills from multiple scopes (first match wins):

1. **Repository** — `.agents/skills/` in current repo
2. **User** — `$HOME/.agents/skills/` (personal cross-repo)
3. **Admin** — `/etc/codex/skills/` (system-wide)
4. **System** — built-in Codex skills
5. **Plugin** — installed plugin skills

## Best Practices

- One skill = one task. Split broad skills into focused ones.
- Description is the trigger mechanism — invest effort here.
- Minimize context footprint — use references for supplementary content.
- Prefer instructions over scripts unless determinism is required.
- Test the skill by invoking it in Codex and verifying the output matches expectations.
