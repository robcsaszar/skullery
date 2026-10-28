#!/bin/bash
# Leak check for skullery. Fails on secret patterns, env files, key files,
# account ids, signed URLs, paths into sibling repos, and the name of the
# private core package outside README.md and CONTEXT.md. Scans the files git
# would commit (staged plus tracked) unless paths are given.
# Usage: tool/leak_check.sh [paths...]
set -u
cd "$(git rev-parse --show-toplevel)" || exit 2
if [ $# -gt 0 ]; then
  files=$(printf '%s\n' "$@")
else
  files=$( (git diff --cached --name-only --diff-filter=ACMR; git ls-files) | sort -u)
fi
status=0
say() { echo "leak: $1"; status=1; }

while IFS= read -r f; do
  [ -z "$f" ] && continue
  [ -f "$f" ] || continue
  base=$(basename "$f")
  case "$base" in
    .env|.env.*|*.env|.dev.vars|*.pem|*.key|*.p12|*.pfx|id_rsa|id_ed25519|*.keystore|credentials.json|service-account*.json)
      say "$f: env or key file name" ;;
  esac
  case "$f" in
    *.jpg|*.jpeg|*.png|*.webp|*.gif|*.sqlite|*.woff|*.woff2|*.ttf) continue ;;
  esac
  hits=$(grep -nE \
    -e 'AKIA[0-9A-Z]{16}' \
    -e 'gh[pousr]_[A-Za-z0-9]{30,}' \
    -e 'github_pat_[A-Za-z0-9_]{20,}' \
    -e 'sk-(ant-|proj-)?[A-Za-z0-9_-]{20,}' \
    -e 'xox[abpr]-[A-Za-z0-9-]{10,}' \
    -e 'eyJ[A-Za-z0-9_-]{15,}\.eyJ[A-Za-z0-9_-]{15,}' \
    -e '-----BEGIN [A-Z ]*PRIVATE KEY' \
    -e '(libsql|turso)://[^ "]+' \
    -e 'X-Amz-(Signature|Credential)=' \
    -e '(api[_-]?key|auth[_-]?token|access[_-]?key|secret[_-]?key|account[_-]?id|client[_-]?secret)["'"'"']?\s*[:=]\s*["'"'"']?[A-Za-z0-9/+_-]{16,}' \
    "$f" || true)
  if [ -n "$hits" ]; then
    echo "$hits" | sed "s|^|leak: $f:|"
    status=1
  fi
  # Paths into sibling repos or a home directory never belong in a commit.
  if [ "$f" != "tool/leak_check.sh" ] && grep -nE -e '/Users/[a-z]+/' -e '\.\./orakl' -e 'orakl/' "$f"; then
    say "$f: path into a home directory or a sibling repo"
  fi
  # The private core is named only inside the override instructions.
  core="larder""_core"
  if [ "$f" != "README.md" ] && [ "$f" != "CONTEXT.md" ] && [ "$f" != "tool/leak_check.sh" ] && grep -nE -e "$core" -e '\.\./larder([^_a-z]|$)' "$f"; then
    say "$f: names the private core or a path into it outside the override instructions"
  fi
done <<< "$files"

if [ $status -eq 0 ]; then echo "leak check: clean"; fi
exit $status
