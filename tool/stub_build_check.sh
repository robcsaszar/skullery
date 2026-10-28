#!/bin/bash
# Clones the committed tree into a temp folder and builds it with the stub
# core and nothing else. Green means a stranger can build this repo.
set -eu
root=$(git rev-parse --show-toplevel)
tmp=$(mktemp -d "${TMPDIR:-/tmp}/skullery-stub-check.XXXXXX")
trap 'rm -rf "$tmp"' EXIT
git clone -q "$root" "$tmp/skullery"
cd "$tmp/skullery"
rm -f pubspec_overrides.yaml
LARDER=stub dart pub get
LARDER=stub tool/gate.sh
echo "stub build check: green (clean clone at $tmp built with the stub core)"
