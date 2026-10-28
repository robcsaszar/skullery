# Skullery

Skullery is a recipe site: recipes written by chefs, cooked and forked by cooks, each with ingredient groups, steps, notes and yields, grouped by kitchen, meal, category and label. The site is static Dart (Jaspr) on Cloudflare Workers, the dynamic part is a Dart container on Fly.io, the database is Turso (libSQL), images live on Cloudflare R2, search is Pagefind. It replaces the old Jekyll site at theskullery.net, which forwards to skullery.net at launch. This repo is MIT and built in public.

The core lives in a private repo named larder. This repo builds and runs with the stub core.

## Layout

```
site/                 the Jaspr static site
apps/                 the Flutter apps
packages/ui           shared UI for the site and the apps
packages/larder_api   the public read interface of the core and the types a frontend renders
packages/larder_stub  a stub core with invented recipes, so this repo builds alone
docs/                 legacy-site.md (what the old site was), process-gaps.md
tool/                 gate.sh, leak_check.sh, stub_build_check.sh
```

## Build with the stub core

```
dart pub get
tool/gate.sh          # dart analyze, dart format check, dart test per package
```

That is the whole setup. A clean clone needs Dart and nothing else; `tool/stub_build_check.sh` proves it by cloning this repo into a temp folder and running the gate there.

## Build with the real core

The real core, larder_core, is a path dependency added through a gitignored `pubspec_overrides.yaml` at the repo root. It is never committed and never referenced from code outside this section:

```
cat > pubspec_overrides.yaml <<'YAML'
dependency_overrides:
  larder_core:
    path: ../larder/packages/core
YAML
LARDER=sqlite dart pub get
```

Remove the file to build with the stub again. The site reads `LARDER=stub` (default) or `LARDER=sqlite` at build time to choose the core.

CONTEXT.md says what Skullery is. CLAUDE.md says how a Claude Code session works here.
