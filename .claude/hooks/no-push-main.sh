#!/bin/bash
# Blocks a `git push` to main and any force push from a Claude Code session.
# main changes only through a pull request: branch, pull request, green ci,
# merge. Bash, jq, grep and sed only.
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
echo "$COMMAND" | grep -qE 'git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?push([[:space:]]|$)' || exit 0

block() { echo "$1" >&2; exit 2; }

# One check per command in a chain, on the words after `git push`.
echo "$COMMAND" | sed -E 's/(&&|\|\||;|\|)/\n/g' | while IFS= read -r part; do
  echo "$part" | grep -qE 'git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?push([[:space:]]|$)' || continue
  seg=$(echo "$part" | sed -E 's/.*git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?push//')
  if echo "$seg" | grep -qE -- '(^|[[:space:]])(-f|--force|--force-with-lease(=[^[:space:]]*)?|--force-if-includes)([[:space:]]|$)' \
    || echo "$seg" | grep -qE '(^|[[:space:]])\+[^[:space:]]*'; then
    echo "force"; exit 0
  fi
  if echo "$seg" | grep -qE '(^|[[:space:]]|:)(refs/heads/)?main([[:space:]]|$)'; then
    echo "main"; exit 0
  fi
  positional=0
  for w in $seg; do case "$w" in -*) ;; *) positional=$((positional + 1)) ;; esac; done
  if [ "$positional" -lt 2 ]; then
    branch=$(git -C "${CLAUDE_PROJECT_DIR:-.}" symbolic-ref --short HEAD 2>/dev/null)
    [ "$branch" = "main" ] && { echo "main"; exit 0; }
  fi
done | head -1 | {
  read -r verdict
  case "$verdict" in
    force) block "force push is blocked. main changes only through a pull request." ;;
    main) block "push to main is blocked. Branch, pull request, green ci, merge; Rob merges." ;;
  esac
}
