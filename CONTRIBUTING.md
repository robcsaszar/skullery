# Contributing

Thank you for looking. This page says how a change gets in.

## Build with the stub

```
git clone https://github.com/robcsaszar/skullery.git && cd skullery
dart pub get
dart run site/tool/build.dart
```

A clean clone needs Dart 3.13.7 and nothing else. The stub core holds five invented recipes; every test and every build in this repo runs against it. You never need the private core.

## The gate

```
tool/gate.sh
```

It runs `dart analyze`, `dart format --set-exit-if-changed` and `dart test` in every package. It must be green before a pull request. CI runs the same script on every push and pull request, plus `tool/leak_check.sh` and `tool/stub_build_check.sh` (a clean clone built with the stub).

## The leak check

```
tool/leak_check.sh
```

It fails on secrets, env and key files, account ids, signed URLs, paths into other repos, and the name of the private core package outside README.md and CONTEXT.md. Run it before every commit. A hit means remove the content, not the pattern.

## Commits and pull requests

- Conventional commits: `type(scope): what`, body says why. Types: feat fix chore docs refactor test build ci perf revert. Scopes: site, apps, ui, api, stub, docs, ci, tooling.
- One pull request per part. A part is one feature, one fix or one document, with its tests.
- The pull request template asks for what, why, how tested, and three checkboxes: gate green, leak check clean, stub build green.
- Glossary words everywhere, in code and copy: recipe, chef, kitchen, category, meal, label, cook, fork, version, change, place, ingredient, ingredient group, item, state, alternative, step, action, inputs, note, yield, larder. Not user, author, cuisine, tag, tweak, variant.
- Every dependency pinned to an exact version, with the release date, Dart 3 support and open issue count in the commit message.

## What a contributor cannot touch

The core lives in a private repo named larder: the data model, the SQL, the parse, the place resolver and the versioning. Nothing that reads, writes or describes it enters this repo. A pull request that adds core logic, imports the private core, or copies a recipe that is not published is closed. The seam is `packages/larder_api`: a change to the interface is a conversation first, in an issue.

## Review

Rob reviews every pull request alone. Small pull requests land faster than large ones. CONTEXT.md says what the project is; CLAUDE.md holds the rules a Claude Code session follows here, and they are the same rules for a person.
