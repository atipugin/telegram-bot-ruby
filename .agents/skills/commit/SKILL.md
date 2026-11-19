---
name: commit
description: Commit current changes as Conventional Commits, split by concern. Use when asked to commit changes or write a commit message.
---

1. Review `git status --short` and `git diff HEAD`, and read untracked files in full — the diff doesn't show them. Check staged and unstaged changes separately so existing staging choices aren't lost.

2. Split changes into one commit per concern. Keep implementation, tests, documentation and generated files together when they support the same change. Separate unrelated changes; each commit should be coherent and independently valid. Stage with paths; for mixed hunks in one file, stage via `git apply --cached` with a hand-made patch.

3. Message format: [Conventional Commits](https://www.conventionalcommits.org) — `type(scope): subject`, all lowercase, imperative, no trailing period, about 50 characters, in English.

   Types: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `style`, `build`, `ci`, `chore`, `revert`. Scope is the affected area (`api`, `types`, `parser`); omit it when the change spans many.

   Add a body only when the subject doesn't explain the change: what changed and why, wrapped at 72 characters. Footers: `BREAKING CHANGE: …` for incompatible changes; `Refs: #123` for a related GitHub issue, when known. Never invent issue references.

   Append an `Assisted-by: <agent-name>/<model-id>` Git trailer to every commit message, including message-only proposals. Use the actual agent name and model ID from the current session; if unavailable, ask rather than guess. Place trailers at the end of the message, separated from the subject or body by a blank line.

4. Show the planned commits (files + messages) and wait for approval before staging or committing. If asked only for a commit message, return the proposed message without staging or committing.
