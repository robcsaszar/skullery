#!/bin/bash
# Blocks a `git commit -m` whose subject is not a conventional commit.
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
if echo "$COMMAND" | grep -qE 'git\s+commit' && echo "$COMMAND" | grep -qE -- "-m[[:space:]]+['\"]"; then
  MSG=$(echo "$COMMAND" | grep -oE -- "-m[[:space:]]+['\"][^'\"]+" | head -1 | sed -E "s/^-m[[:space:]]+['\"]//")
  if [ -n "$MSG" ] && ! echo "$MSG" | grep -qE '^(feat|fix|chore|docs|refactor|test|build|ci|perf|revert)(\([a-z0-9_-]+\))?!?: \S+'; then
    echo "commit subject must be conventional: type(scope): what. Types: feat fix chore docs refactor test build ci perf revert" >&2
    exit 2
  fi
fi
exit 0
