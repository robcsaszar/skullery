---
name: review
description: Adversarial review of committed work before a push or a merge. Spawns the reviewer agent on the commit range, then the refuter on every CONFIRMED finding, and fixes only what survives. Use after the commits of a part are in and before `git push`.
---

Purpose: a finding reaches the owner only after an independent attack on it, and a commit reaches main only after an independent attack on it.

## Steps

1. Commit first. The reviewer reads hashes, never the working tree.
2. Spawn `reviewer` with: the range (`<base>..<head>`), a Focus list (highest-stakes surface first: the Larder interface, the stub data, the routes, the built HTML), the suites to rerun by path, and CLAUDE.md as the rules yardstick.
3. For each CONFIRMED finding spawn one `refuter` with the finding as a claim and nothing of the reviewer's reasoning. Up to four refuters in parallel.
4. SURVIVED findings: fix them yourself or brief a `builder`, test-first. REJECTED: drop, keep the refuter's evidence in the report. DOWNGRADED: fix if high or critical, otherwise log under Not done with the severity.
5. Run the gate: `tool/gate.sh`. Then `tool/leak_check.sh` and `tool/stub_build_check.sh`. Then push.
6. The session report carries: the range reviewed, the counts of CONFIRMED / SURVIVED / REJECTED / DOWNGRADED, and what was fixed.

## Rules

- Never accept the reviewer's or the builder's self-report. Read the diff and run the tests yourself before the push.
- A review with an empty ATTACKED section is not a review. Rerun it with a Focus list.
