---
name: prose
description: Drafts and revises the human-facing text of this repo (README, docs, issue and pull request templates, site copy). Use when writing or rewriting anything a stranger reads. Not for code comments or commit messages.
---

Purpose: text a stranger can trust. Every sentence rests on a fact in CONTEXT.md or on a plan marked as a plan.

Adapted from the prose skill in the orakl repo: its Documentation channel rules and required checks, without the voice calibration, the scanner and the blog, email and social rules. This repo has one voice, set below.

## Before writing

1. Name the reader and what they need to do after reading. The README reader decides whether to clone; a template reader fills in a form.
2. Name the single job of the text: inform, instruct or invite. One job per text.
3. Type every claim before writing it: a fact (in CONTEXT.md, in the code, in a command's output), a plan (goes under Planned, in the future tense or with "planned"), or a gap (say it is missing). A claim with no type is cut.

## The voice

- Sentence case everywhere, headings included. No exclamation marks. No superlatives, no "revolutionary", no "seamless", no "robust", no "powerful". No emoji in headings.
- British spelling: licence, colour, organise.
- Short sentences, plain words. Repeat the ordinary word when it is the right word. Verbs over nouns made from verbs.
- Glossary words only: recipe, chef, kitchen, category, meal, label, cook, fork, version, change, place, ingredient, ingredient group, item, state, alternative, step, action, inputs, note, yield, larder. Never user, author, cuisine, tag, tweak, variant.
- What exists goes under "Today", what is planned under "Planned". A reader tells the two apart in one glance.
- Documentation shape: headings, steps and lists where they help scanning; uniform sentence length is right here. No hooks, no suspense, no closing question.

## Draft

- Each paragraph carries one concrete anchor: a number, a path, a command, a name a reader can check. "Many", "various", "powerful" fail the test.
- Commands, paths, package names and licence names are fixed strings. Copy them exactly from the repo; never retype from memory.
- Links go to things that answer today. A planned address is named as planned, not linked as live.
- Fewer verified facts beat more guessed ones. Leave `[VERIFY]` rather than invent.

## Check before committing

1. Register fit: does the shape match the medium (README, template, site copy)?
2. Anchor audit: point at the anchor in every paragraph.
3. Fact discipline: pick the three most fragile claims (dates, counts, future claims) and check each against CONTEXT.md, the code or a command run in this session.
4. Today and Planned: nothing under Today that cannot be run now; nothing under Planned that already runs.
5. Regularity: the same sentence opening three times in a row, or three list items that could be one, gets rewritten.
6. Verbatim integrity: every command, path, name and licence string unchanged from the source.
7. Staging: no "here is the thing", no "imagine", no rhetorical question answered on the spot.
8. Over-correction: no slang, no typos, no forced asides added to sound human.
9. Run `tool/leak_check.sh`. Prose is scanned like code.

## Never

- Never state a plan as a fact. Never state a fact the session did not verify.
- Never praise the project. Say what it does and let the reader judge.
- Never remove a heading, a list or a link to make the text read smoother. Structure is what makes documentation usable.
