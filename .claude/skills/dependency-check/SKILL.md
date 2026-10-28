---
name: dependency-check
description: Checks a package before it is added to a pubspec. Use whenever a session wants a new dependency or bumps one. Produces the three facts the commit message must carry.
---

Purpose: every dependency is pinned, alive and justified. Prefer the SDK over a package.

## Steps

1. Ask first: can the SDK do it? `dart:convert`, `dart:io` (adapters and tools only), `dart:typed_data`, `dart:ffi`. If yes, no package.
2. Fetch the facts, no login needed: `curl -s https://pub.dev/api/packages/<name>` gives the latest version and its `published` date. The repository link in the pubspec gives the issue tracker; `gh api repos/<owner>/<repo> --jq .open_issues_count` gives the open issue count.
3. Pass only if: last release under 12 months, Dart 3 support (`sdk: ^3` or `>=3` in its environment), and the issue count is known.
4. Pin the exact version in pubspec.yaml (`sqlite3: 3.1.2`, no caret) and commit the root pubspec.lock.
5. Commit message body carries the three facts: `sqlite3 3.1.2: released 2026-09-02, Dart 3, 41 open issues`.
6. Updates: `dart pub outdated` lists them. Bump deliberately, one package per commit, same three facts. Dependabot opens the pull requests once CI exists.
