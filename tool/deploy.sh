#!/bin/bash
# Deploys the static site, built with the real core, to the workers.dev
# preview. Runs on Rob's machine only, never from CI. Needs LARDER_PATH, the
# path to the private core repo relative to this repo root, and a wrangler
# login in the home folder (`npx wrangler login`, once, from site/).
# Order: sqlite build, gate, leak check over the tracked files and the build
# output, deploy. Ends by restoring the stub resolution of pubspec.lock.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
: "${LARDER_PATH:?set LARDER_PATH to the path of the private core repo, relative to this repo root}"

LARDER=sqlite LARDER_PATH="$LARDER_PATH" dart run site/tool/build.dart
tool/gate.sh
# pubspec.lock holds the private path after a sqlite build; the override file
# restores the stub resolution below, so the check covers the rest of the
# tree and everything that ships.
tool/leak_check.sh $(git ls-files | grep -vx 'pubspec.lock') $(find site/build/jaspr -type f)

out=$(mktemp)
(cd site && npx wrangler deploy 2>&1 | tee "$out")
url=$(grep -oE 'https://[a-z0-9.-]+\.workers\.dev' "$out" | head -1)
rm -f "$out"

rm -f pubspec_overrides.yaml
dart pub get > /dev/null
echo
echo "deployed: ${url:-see the wrangler output above}"
