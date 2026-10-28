---
name: leak-check
description: Runs the leak check before a commit or a push. Use before every commit, before any push, and whenever a file from outside the repo was copied in. Fails on secrets, env and key files, account ids, signed URLs, the name of the private core package outside the override instructions, and paths into sibling repos.
---

Purpose: nothing secret, nothing of the private core and nothing from a sibling repo reaches git.

## Steps

1. Stage what you mean to commit, then run `tool/leak_check.sh`. It scans staged and tracked files. Pass paths to scan untracked files: `tool/leak_check.sh path/one path/two`.
2. A hit means stop. Remove the content, not the pattern. Do not add an allow-list entry to make the check pass.
3. If a real secret was committed earlier: say so in the report, rotate it the same day, remove it from history, then push.
4. The hook in .claude/settings.json runs the same script on every `git commit` from a Claude Code session. A red check blocks the commit.

## What it catches

Cloud keys, GitHub tokens, API keys, Slack tokens, JWTs (Turso tokens are JWTs), private keys, libsql and turso URLs, signed URL query strings, `api_key = ...` style assignments, env and key file names, home directory paths, paths into orakl, the private core package name and a relative path into the larder repo in any file other than README.md and CONTEXT.md.

## What it does not catch

A password in prose, a bucket name without a scheme, core logic rewritten in a frontend. Read the diff before you commit, and ask: does this file describe how the core works? Then it does not belong here.
