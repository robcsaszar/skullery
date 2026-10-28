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
docs/                 legacy-site.md, process-gaps.md, handoff/
tool/                 gate.sh, leak_check.sh, stub_build_check.sh
.claude/              agents, skills and hooks for Claude Code sessions
```

The root pubspec.yaml is a Dart workspace. A package joins the `workspace:` list when it gets code.

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
```

`LARDER=stub` is the default for the site build. `tool/stub_build_check.sh` clones the repo into a temp folder and runs the gate there, which is the test that a stranger can build it.

## Build with the real core

A gitignored `pubspec_overrides.yaml` at the repo root adds the private core as a path dependency:

```
dependency_overrides:
  larder_core:
    path: ../larder/packages/core
```

Then `LARDER=sqlite dart pub get` and the site build reads larder/build/skullery.sqlite and copies larder/build/images/legacy into site/web/images/legacy (gitignored). Delete the override file to return to the stub. The override file and the two paths above are the only place this repo names the private core.

## The pages of the site

- Home: the recipe collection, newest first, 20 per page, with schema.org ItemList data.
- Recipe: /recipe/<slug>. Title, summary, image, chef, meal, categories, kitchen, labels, yields, ingredient groups with ingredients (amount, unit, raw text), steps in order, notes, schema.org Recipe data, a small "not yet reviewed" mark when reviewed is false.
- Collections and singles: /category/<slug>, /chef/<slug>, /meal/<slug>, /kitchen/<slug>, /label/<slug>.
- Placeholders with a title and one line: about, privacy, terms, cookies, open, status, colophon, faq, 404, 500.
- Later: search (Pagefind), favorites, scaling, checklist, exports, forks. docs/legacy-site.md records what the old site had.

## Glossary

recipe, chef (not author), kitchen (not cuisine or tag), category, meal, label, cook (not user), fork (not tweak or variant), version, change, place (the position of an entity: the id of the next sibling or "end", never an order number), ingredient, ingredient group, item, state, alternative, step, action, inputs, note, yield, larder.

## Known gaps

- No code yet in any package. The first code session adds larder_api, larder_stub and the site.
- No CI yet. The gate runs locally; CI comes with the first code (see docs/process-gaps.md).
