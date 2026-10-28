#!/bin/bash
# The gate: analyze, format check and tests for every workspace package.
# `dart test` does not run at a workspace root, so tests run per package,
# found by their pubspec.yaml. A package without a test folder is skipped.
set -eu
cd "$(git rev-parse --show-toplevel)"
dart analyze
dart format --set-exit-if-changed .
for pubspec in $(find site apps packages -name pubspec.yaml -not -path '*/.dart_tool/*' -not -path '*/build/*' 2>/dev/null | sort); do
  pkg=$(dirname "$pubspec")
  [ -d "$pkg/test" ] || continue
  if grep -q '^  flutter:' "$pubspec"; then
    (cd "$pkg" && flutter test)
  else
    (cd "$pkg" && dart test)
  fi
done
echo "gate: green"
