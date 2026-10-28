<!-- Banner: docs/media/banner-light.svg and docs/media/banner-dark.svg, each 1200 by 300. -->
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/media/banner-dark.svg">
  <img src="docs/media/banner-light.svg" alt="Skullery" width="1200" height="300">
</picture>

Skullery is a recipe site that grows into a platform: recipes written by chefs, cooked and forked by cooks.

[![ci](https://github.com/robcsaszar/skullery/actions/workflows/ci.yml/badge.svg)](https://github.com/robcsaszar/skullery/actions/workflows/ci.yml)
[![code: MIT](https://img.shields.io/badge/code-MIT-blue.svg)](LICENSE.md)
[![recipes: CC BY-SA 4.0](https://img.shields.io/badge/recipes-CC%20BY--SA%204.0-blue.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

## Why

Recipes are open content. The 164 recipes from the old site, theskullery.net, built in 2020 on Jekyll, carry over under CC BY-SA 4.0. Anyone can read them without an account, copy them, and build on them, as long as they share alike.

A fork is the idea. A cook takes a chef's recipe, changes it, cooks it, and merges the change back into a recipe of their own. The original stays as it was. Every version is kept, so a recipe can be followed back to where it came from.

Paper is a first-class input. A recipe can be printed as a form, written on at the stove, photographed, and read back as a fork. The kitchen does not have to go through a screen.

## Today

- The repo builds on a clean clone with a stub core of five invented recipes, with no account and no secret.
- Built against the real core, the static site renders the 164 recipes from the old site as plain HTML: one page per recipe, chef, kitchen, meal, category and label.
- Tests run on every push: `dart analyze`, `dart format`, `dart test` per package, a leak check and the clean-clone build.
- Nothing is deployed yet. The old site stays up until launch and then forwards to skullery.net.

## Planned

In this order:

1. The new site.
2. Accounts and submissions.
3. Forks: a cook forks a recipe, changes it, merges it back into a recipe of their own.
4. Apps, in Flutter.
5. A cooking dictionary.
6. An assistant that edits a recipe by voice or in plain English.
7. Paper forks: print a recipe as a form, write on it, photograph it, get a fork.

Principles that hold through the list: no ads, no bloat text, no login to read, simplicity first, no vendor lock-in, few usage-based bills, and build in public with the core closed. One cook, Rob, builds it.

## Build it

```
git clone https://github.com/robcsaszar/skullery.git && cd skullery
dart pub get
dart run site/tool/build.dart
```

That builds the site from the stub core into site/build/jaspr. The build with the real core takes one environment variable and a gitignored override file; CONTEXT.md describes it under "Build with the real core".

## How this repo relates to the core

The core lives in a private repo named larder. This repo builds and runs with the stub core.

The core holds the data model, the recipe versioning and the merge. It stays closed so the platform has one owner for the parts that carry trust. This repo holds the site, the apps, the shared UI, `larder_api` (the read interface the frontends use) and `larder_stub` (a core with invented recipes). Nothing here imports the private core; a contributor never needs it.

## Contributing

Pull requests are welcome for the site, the apps, the UI and the interface. Build with the stub, keep the gate green, one pull request per part. CONTRIBUTING.md has the steps, the checks and what a contributor cannot touch. Rob reviews every pull request alone, so small ones land faster.

## Licence

The code in this repo is MIT, see [LICENSE.md](LICENSE.md). The recipes are [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).

## Credits

Built by Rob ([NHG.design](https://nhg.design)). The recipes come from the old site, [theskullery.net](https://theskullery.net).
