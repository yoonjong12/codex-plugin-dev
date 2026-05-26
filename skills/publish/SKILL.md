---
name: publish
description: Publish a Codex plugin — version bump, git tag, and marketplace registration. Use when the user says "publish plugin", "release plugin", "bump version", "ship update", "tag release", or mentions versioning a Codex plugin.
---

# Publish Plugin

Automate the release workflow for a Codex CLI plugin.

## Steps

### 1. Validate First

Before publishing, run validation:

```bash
bash "${PLUGIN_ROOT}/skills/validate/scripts/validate-plugin.sh" "<plugin-dir>"
```

Do not proceed if validation fails.

### 2. Version Bump + Tag

```bash
bash "${PLUGIN_ROOT}/skills/publish/scripts/publish.sh" "<major|minor|patch>" "<plugin-dir>"
```

This script:
1. Reads current version from `.codex-plugin/plugin.json`
2. Bumps according to semver rule
3. Updates `plugin.json`
4. Commits the change
5. Creates a git tag `v<new-version>`
6. Prints push and registration commands

### 3. Push to Remote

After the script runs, push to GitHub:

```bash
git push origin main --tags
```

### 4. Register in Codex Marketplace

For first-time registration:

```bash
codex plugin marketplace add <owner>/<repo>
```

For updates, users run:

```bash
codex plugin marketplace upgrade <marketplace-name>
```

See `references/marketplace-spec.md` for marketplace.json format and advanced configuration.

## Version Strategy

| Change Type | Bump | Example |
|------------|------|---------|
| Breaking API change | major | 0.1.0 → 1.0.0 |
| New skill or feature | minor | 0.1.0 → 0.2.0 |
| Bug fix or docs | patch | 0.1.0 → 0.1.1 |
