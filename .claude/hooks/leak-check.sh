#!/bin/bash
# Runs tool/leak_check.sh before any `git commit` from a Claude Code session.
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
if echo "$COMMAND" | grep -qE 'git\s+commit'; then
  cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
  if ! out=$(bash tool/leak_check.sh 2>&1); then
    echo "$out" >&2
    echo "leak check failed; the commit is blocked" >&2
    exit 2
  fi
fi
exit 0
