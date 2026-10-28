---
name: stub-build-check
description: Proves the repo builds on a clean clone with the stub core. Use before every push and after any pubspec change. Clones the repo into a temp folder, runs dart pub get and the gate there.
---

Purpose: a stranger with Dart and nothing else can build this repo.

## Steps

1. Commit first. The check clones the committed tree, not the working tree.
2. `tool/stub_build_check.sh`. It clones the repo into a folder under the system temp dir, runs `dart pub get` and `tool/gate.sh` there with no override file and `LARDER=stub`, and deletes the clone.
3. Red means a file the build needs is not committed, a dependency is not pinned in the lock, or something imports the private core. Fix at the cause, never by adding the missing file to the clone.
4. The session report carries the result.
