#!/usr/bin/env bash
set -euo pipefail

AGENT_NAME="${1:?Usage: init-agent.sh <agent-name> [plugin-dir]}"
PLUGIN_DIR="${2:-.}"
AGENT_FILE="$PLUGIN_DIR/agents/$AGENT_NAME.toml"

mkdir -p "$PLUGIN_DIR/agents"

if [ -f "$AGENT_FILE" ]; then
  echo "ERROR: $AGENT_FILE already exists"
  exit 1
fi

cat > "$AGENT_FILE" <<EOF
name = "$AGENT_NAME"
description = "TODO — describe when and why to use this agent"
developer_instructions = """
TODO — write behavioral guidance for this agent.
Include:
1. What to analyze or produce
2. What constraints to follow
3. What format to report in
"""
# model = "gpt-5.4"
# sandbox_mode = "read-only"
# nickname_candidates = ["Name1", "Name2"]

# [mcp_servers.example]
# url = "stdio://example-server"
EOF

echo "OK: created agent '$AGENT_NAME' at $AGENT_FILE"
echo "Next: edit $AGENT_FILE to fill in description and instructions."
