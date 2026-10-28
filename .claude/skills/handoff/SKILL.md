---
name: handoff
description: Compacts the current session into a handoff note for the next session. Use when a session ends with work open, or when the user asks for a handoff.
argument-hint: "What the next session will do"
disable-model-invocation: true
---

Purpose: the next session starts from facts, not from a re-read of this one.

## Steps

1. Write the note to docs/handoff/<yyyy-mm-dd>-<topic>.md. It is committed: the project files are the source of truth.
2. Contents, in this order: the goal, what is done (commits by hash), what is open (one line each, with the file it lives in), decisions taken and the alternative not taken, the exact commands that reproduce the current state, open questions for the owner, suggested skills to invoke.
3. Do not duplicate what CONTEXT.md, a commit message or a test already says. Point at it by path or hash.
4. Redact anything secret or personal. The leak check runs on the note like on any file.
5. If the user passed an argument, it names what the next session will focus on. Tailor the note to it.
