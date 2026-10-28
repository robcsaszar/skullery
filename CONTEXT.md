# skullery

Skullery is a recipe site in Dart. This repo is its public half: the Jaspr static site, the Flutter apps, the shared UI, larder_api (the read interface of the core) and larder_stub (a stub core with invented recipes). The private half, larder, holds the core: models, schema, parse, place resolver, versioning, and the server. Principle: build in public, keep the larder closed. The old site, theskullery.net, forwards to skullery.net at launch.

## The split with larder

| | skullery (this repo, public, MIT) | larder (private, all rights reserved) |
|---|---|---|
| holds | site, apps, ui, larder_api, larder_stub | core, adapters, host, parse, migrations |
| knows | the `Larder` read interface and its types | everything |
| builds with | larder_stub by default, larder_core through a gitignored override | its own packages |
| deploys | static site to Cloudflare Workers, apps to the stores | the Dart container to Fly.io |

larder depends on this repo's larder_api (a git dependency pinned to a commit). This repo never depends on larder in a committed file.

## Layout

```
site/                 Jaspr, static rendering mode; output is plain HTML, CSS and JavaScript
apps/                 Flutter apps; one folder per app
packages/ui           shared UI for the site and the apps
packages/larder_api   pure Dart: the Larder interface and the immutable types (Recipe, IngredientGroup, Ingredient, Amount, Step, Note, Yield, Image, Chef, Category, Meal, Kitchen, Label)
packages/larder_stub  a Larder with a handful of invented recipes
packages/larder_select  openLarder() and legacyImagesDir() over the stub; not a workspace member, so a pubspec override can swap it
docs/                 legacy-site.md, process-gaps.md, handoff/
tool/                 gate.sh, leak_check.sh, stub_build_check.sh
.claude/              agents, skills and hooks for Claude Code sessions
```

The root pubspec.yaml is a Dart workspace. A package joins the `workspace:` list when it gets code. packages/larder_select stays out of the list on purpose: pub overrides a path dependency, never a workspace member.

## Stack

- Dart 3.13.7 (stable), installed with Homebrew from the dart-lang/dart tap. The SDK changes only by a decision recorded here.
- Jaspr, newest stable, static mode, through `dart run jaspr_cli:jaspr` as a dev dependency. jaspr_router for the routes.
- Flutter for the apps, pinned per app pubspec.
- Hosting: static site on Cloudflare Workers; dynamic calls to the larder host on Fly.io; database Turso (libSQL), behind the host, never reached from here; images on Cloudflare R2, served through the Worker; search with Pagefind over the built HTML.
- No env file anywhere. The static build needs no secret. Deploy credentials live in the host's secret store and reach it through CI.

## Build with the stub core

```
dart pub get
tool/gate.sh
dart run site/tool/build.dart
```

`LARDER=stub` is the default. `tool/stub_build_check.sh` clones the repo into a temp folder and runs the gate there, which is the test that a stranger can build it. The site build runs Jaspr's CLI as a dev dependency (`dart run jaspr_cli:jaspr build`), never as a global tool, and writes site/build/jaspr.

## Build with the real core

```
LARDER=sqlite LARDER_PATH=../larder dart run site/tool/build.dart
```

The build tool writes a gitignored `pubspec_overrides.yaml` at the repo root that points `larder_select` at the private repo's package of that name (`../larder/packages/select`), which opens the parsed SQLite file through the real core, larder_core. It also copies the legacy images into site/web/images/legacy (gitignored). The stub build removes both. The override file, the two paths in this section and the README are the only places this repo names the private core. A pubspec.lock resolved with the override holds the private path; the leak check fails on it, so build with the stub before a commit.

## Known constraints

- Jaspr's CLI pins analyzer ^12, so `test` is 1.31.1 and build_web_compilers 4.8.5 across the workspace until Jaspr moves. One resolution per workspace.
- jaspr_cli checks that `which dart` sits inside the SDK folder; the Homebrew symlink does not, so the build tool puts the running SDK's bin folder first on PATH for the CLI. It also sets JASPR_NO_COMPLETION so the CLI does not write shell completion files.
- Routes carry no path parameters: static generation renders one route per page, so the router lists every recipe and lookup as its own route.
- A static host serves /recipe/<slug> from recipe/<slug>/index.html; python's http.server answers the bare path with a 301 to the slash form.

## The pages of the site

- Home: the recipe collection, newest first, 20 per page, with schema.org ItemList data.
- Recipe: /recipe/<slug>. Title, summary, image, chef, meal, categories, kitchen, labels, yields, ingredient groups with ingredients (amount, unit, raw text), steps in order, notes, schema.org Recipe data, a small "not yet reviewed" mark when reviewed is false.
- Collections and singles: /category/<slug>, /chef/<slug>, /meal/<slug>, /kitchen/<slug>, /label/<slug>.
- Placeholders with a title and one line: about, privacy, terms, cookies, open, status, colophon, faq, 404, 500.
- Later: search (Pagefind), favorites, scaling, checklist, exports, forks. docs/legacy-site.md records what the old site had.

## Glossary

recipe, chef (not author), kitchen (not cuisine or tag), category, meal, label, cook (not user), fork (not tweak or variant), version, change, place (the position of an entity: the id of the next sibling or "end", never an order number), ingredient, ingredient group, item, state, alternative, step, action, inputs, note, yield, larder.

## Known gaps

- packages/ui and apps/ have no code yet.
- No CI yet. The gate runs locally; CI comes with the first code (see docs/process-gaps.md).
