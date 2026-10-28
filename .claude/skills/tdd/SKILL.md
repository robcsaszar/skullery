---
name: tdd
description: Test-first work in Dart. Use when building a feature or fixing a bug, when the user says red-green or test-first, or when a bug report arrives without a test.
---

Purpose: one failing test, the code that passes it, the next test. Never all tests first.

## Rules

- Tests verify behaviour through the public interface of the package (`package:larder_api/larder_api.dart` for the stub, a page or a widget for the frontends), not implementation details. A test that breaks on a rename without a behaviour change was testing implementation.
- A bug fix starts with a test that reproduces the bug and fails. Then the fix. Then the test is green. Keep the test.
- Vertical slices: test one → code one → test two → code two. Tests written in bulk assert imagined behaviour and the shape of data.
- Expected values are literals from the brief or the old data, never recomputed the way the code computes them.
- No network, no clock without injection. Every frontend test runs against larder_stub.
- Fixtures are the invented stub recipes. Never a real recipe of another chef, never a cook's data.

## Loop

```
1. write the test in packages/<pkg>/test/<area>_test.dart
2. cd packages/<pkg> && dart test test/<area>_test.dart    -> red
3. minimal code
4. same command                                              -> green
5. dart analyze && dart format <files>
6. next behaviour
```

At the end, once: `tool/gate.sh`.
