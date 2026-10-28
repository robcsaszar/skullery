# skullery: rules for a Claude Code session

Read CONTEXT.md first. It says what Skullery is; this file says how to work in it.

## Scope and privacy

- skullery is public, MIT. larder is private. Nothing that reads, writes or describes the core logic enters this repo: no SQL, no parse, no place resolver, no versioning logic, no schema.
- Frontends import larder_api only. The private core package is named only in README.md and CONTEXT.md, inside the override instructions. The leak check fails on the name anywhere else.
- No env file, secret, token, account id, bucket name or signed URL in any commit, branch, fixture or doc. Not even an example file.
- A secret that touches git gets rotated the same day, then removed from history.
- No personal data of a cook and no unpublished recipe of another chef in a repo, fixture or test. The stub recipes are invented.
- No path into a sibling repo in any file except the override instructions in README.md and CONTEXT.md.
- The repo builds on a clean clone with the stub core: `tool/stub_build_check.sh` proves it and runs before every push.
- Run `tool/leak_check.sh` before every commit. The hook in .claude/settings.json runs it on `git commit`; a red check does not commit.
- Do not write into the sibling repos: the old site clone (theskullery) and the orakl project are read only.

## Vocabulary

- Use the glossary words everywhere, in code, copy and docs: recipe, chef, kitchen, category, meal, label, cook, fork, version, change, place, ingredient, ingredient group, item, state, alternative, step, action, inputs, note, yield, larder.
- Never: user, author, cuisine, tag, tweak, variant, order number.
- Position is a place: "the id of the next sibling" or "end". A frontend renders the order it receives and never computes one.

## Architecture

- Three layers live in larder: core, adapter, host. This repo is the frontend layer: it talks to the `Larder` interface in packages/larder_api and nothing below it.
- larder_api is pure Dart with no dependency beyond the SDK: immutable types and read methods. No logic, no SQL.
- larder_stub implements `Larder` with a handful of invented recipes. Every frontend builds and its tests run against the stub.
- The site is static: every page is HTML at build time. Interactivity comes later and stays small.
- Images are addressed by key. The original bytes and every variant live in the image store, never in this repo.

## Dart and dependencies

- Dart stays on the newest stable, recorded in CONTEXT.md. The SDK on a machine changes only by a decision written in CONTEXT.md.
- Every dependency pinned: an exact version in pubspec.yaml and the root pubspec.lock committed. `^` ranges only for the SDK constraint.
- Before adding a dependency: last release under 12 months, Dart 3 support, open issue count. Put the three facts in the commit message. Prefer the SDK over a package. Run the dependency-check skill.
- No global tool installs without a note in the session report. Jaspr's CLI runs as a dev dependency (`dart run jaspr_cli:jaspr`), not as a global tool. No `curl | sh`.

## Code

- `dart analyze` clean and `dart format` applied on every commit. Gate: `tool/gate.sh` (analyze, format check, tests per package).
- Newest `lints` package, recommended set, strict-casts, strict-inference and strict-raw-types on. No rule turned off without a comment that says why.
- snake_case files, UpperCamelCase classes, lowerCamelCase members, one public class per file unless the classes are a sealed family. English only.
- Semantic HTML first. No framework CSS, no component library. Copy is sentence case, no exclamation marks.
- Comments and docs state the system as it is. Never "used to", "previously", "no longer".
- Minimum code for the ask. No speculative abstraction, config or error handling for cases that cannot happen.
- Touch only what the task requires. Do not reformat or refactor adjacent code.

## Tests

- Every package has tests. A bug fix starts with a failing test. One test, then the code that passes it, then the next: see the tdd skill.
- No test touches the network. Site and app tests run against larder_stub.
- Red tests do not merge. Red tests do not get pushed to main either.

## Git

- Conventional commits: `type(scope): what`, body says why. Types: feat fix chore docs refactor test build ci perf revert. Scopes: site, apps, ui, api, stub, docs, ci, tooling.
- One commit per logical part.
- Until the first deploy: push to main. From the first deploy: branch, pull request, green tests, merge. Nothing live without a pull request.
- Use `gh` for GitHub. Never force-push main. Never `git reset --hard`, `git checkout --` or `git stash` on a tree another agent is editing.
- The session owns git. Subagents never commit, stage or stash.
- Before every push: `tool/leak_check.sh` clean, `tool/stub_build_check.sh` green.

## Working style

- State assumptions up front. Two readings with different results: present both, do not pick silently.
- A simpler approach exists: say so and push back, then build what was asked if the ask stands.
- A multi-step task starts with a plan, one line per step with its check: `1. <step> -> verify: <command>`.
- Build a thin end-to-end slice first, then widen.
- Decisions taken inside a session go into the report under "Decisions to know about" and, when they last, into CONTEXT.md. Project files are the source of truth, not code comments.
- The session report is one paste-able block, re-issued in full after every follow-up. It lists every value or file the brief did not cover. Shape: see the session-report skill.
- Delegate reading, locating and checking to subagents (scout, verifier, refuter, reviewer, builder in .claude/agents). Keep planning, judgment and git for yourself. Verify a subagent's work from the tree, never from its report.
- Be concise. Lead with the result. No praise, no filler.
