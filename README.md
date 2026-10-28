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
packages/larder_select  the one seam that picks the core: the stub here, the real core through the override below
docs/                 legacy-site.md (what the old site was), process-gaps.md
tool/                 gate.sh, leak_check.sh, stub_build_check.sh
```

## Build with the stub core

```
dart pub get
tool/gate.sh          # dart analyze, dart format check, dart test per package
```

That is the whole setup. A clean clone needs Dart and nothing else; `tool/stub_build_check.sh` proves it by cloning this repo into a temp folder and running the gate there.

## Build the site

```
dart run site/tool/build.dart                                        # stub core, 5 invented recipes
LARDER=sqlite LARDER_PATH=../larder dart run site/tool/build.dart    # real core, the parsed recipes
```

The output is plain HTML, CSS and JavaScript in site/build/jaspr. Serve it with any static server.

## Build with the real core

The site chooses its core through one package, `larder_select` (packages/larder_select), which opens the stub. The private repo has a package of the same name over the real core, larder_core. `LARDER=sqlite` makes the build tool write a gitignored `pubspec_overrides.yaml` at the repo root that points the name at that folder, and copy the legacy images into site/web/images/legacy (gitignored):

```
dependency_overrides:
  larder_select:
    path: ../larder/packages/select
```

`LARDER_PATH` is the private repo's path relative to this repo root. The stub build removes the override and the images again. Never commit the override or a pubspec.lock resolved with it; the leak check fails on both.

CONTEXT.md says what Skullery is. CLAUDE.md says how a Claude Code session works here.
