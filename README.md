# codex-plugin-dev

Codex CLI native plugin development toolkit.

Scaffold, develop, validate, and publish Codex plugins — entirely within Codex CLI using shell-script driven workflows.

## Skills

| Skill | Purpose |
|-------|---------|
| `create-plugin` | Scaffold a new Codex plugin from scratch |
| `skill-dev` | Create and structure skills (SKILL.md + references + scripts) |
| `hook-dev` | Develop hooks with linting and testing |
| `agent-dev` | Author subagent definitions (.toml) |
| `mcp-dev` | Integrate MCP servers and app connectors |
| `validate` | Validate plugin structure, manifest, and components |
| `publish` | Version bump, git tag, and marketplace registration |

## Install

```bash
codex plugin marketplace add yoonjong12/codex-plugin-dev
```

## Usage

Invoke any skill by name in conversation:

```
@create-plugin "A PR review toolkit with security scanning"
@validate ./my-plugin
@publish patch
```

## Architecture

Designed for Codex CLI's shell-based runtime:
- Each skill is self-contained (no cross-skill chaining)
- Heavy logic lives in `scripts/` (bash)
- Domain knowledge in `references/` (progressive disclosure)
- Conversational prompts replace interactive UI

## License

MIT
