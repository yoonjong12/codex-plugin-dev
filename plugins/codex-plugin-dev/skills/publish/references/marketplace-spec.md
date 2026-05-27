# Codex Marketplace Specification

## Marketplace JSON

A marketplace is a git repository containing a `marketplace.json` that indexes plugins.

### Location

- Repository: `$REPO_ROOT/.agents/plugins/marketplace.json`
- Personal: `~/.agents/plugins/marketplace.json`
- Legacy: `$REPO_ROOT/.agents/plugins/marketplace.json` (same location, prior naming convention)

### Format

```json
{
  "name": "my-marketplace",
  "interface": {
    "displayName": "My Plugin Collection"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "source": {
        "source": "local",
        "path": "./plugins/my-plugin"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Development"
    }
  ]
}
```

### Source Types

| Type | Config | Use Case |
|------|--------|----------|
| local | `"path": "./relative/path"` | Same-repo plugin |
| git | `"url": "https://..."` | Remote repo |

### Policy Options

- `installation`: `"AVAILABLE"` (opt-in) or `"REQUIRED"` (auto-install)
- `authentication`: `"ON_INSTALL"` (auth at install) or `"ON_USE"` (auth at first use)

## CLI Commands

Two command groups — marketplace (source management) vs plugin (installation):

### Marketplace commands (manage sources)

```bash
codex plugin marketplace add <owner>/<repo>
codex plugin marketplace add <owner>/<repo> --ref <branch>
codex plugin marketplace add ./local-path
codex plugin marketplace list
codex plugin marketplace upgrade [name]
codex plugin marketplace remove <name>
```

### Plugin commands (manage installations)

```bash
codex plugin add <plugin-name>@<marketplace-name>
codex plugin remove <plugin-name>
codex plugin list
```

`marketplace add` registers a source. `plugin add` installs a specific plugin from a registered marketplace.

## Same-Repo Marketplace

For plugins that live in the same repo as the marketplace:

```json
{
  "source": { "source": "local", "path": "./" }
}
```

This is the simplest setup for single-plugin repositories.
