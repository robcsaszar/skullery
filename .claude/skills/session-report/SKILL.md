---
name: session-report
description: Writes the session report as one paste-able block. Use at the end of every session and after every follow-up; the block is re-issued in full each time.
---

Purpose: one block the owner can paste anywhere, complete on its own.

## Shape

```
Repos: <url> (<visibility>, <default branch>) ...
Commits: <hash> <subject> ... one line each, per repo
Done: <part> — <result with numbers>
Tests: <command> — <counts>
Checks: leak check <clean|hits>, parse check <match|diff>
Values the brief did not cover: <every tag, unit, category, key, file or value seen that the brief did not list>
Decisions to know about: <each decision taken inside the session, one line, with the alternative not taken>
Not done: <what and why>
Manual steps for the owner: <logins, approvals, renames> or none
Secrets or env files committed: none.
```

## Rules

- Numbers come from command output in this session, never from memory.
- Re-issue the whole block after every follow-up, updated, not a delta.
- A decision that lasts also goes into CONTEXT.md in the same session.
- Nothing in the block is a secret, an account id or a path into a home directory.
