---
name: update-api
description: Update the generated types and endpoints to the latest Telegram Bot API
---

Update the gem to the latest Telegram Bot API. `rakelib/README.md` explains how the parser works and where to fix it when it fails.

## 1. Fetch the docs

Record HEAD and the highest supported Bot API version in `CHANGELOG.md` (not the gem version). Keep this baseline even if the changelog changes; compare versions numerically.

```
bundle exec rake docs:fetch
```

Always run step 5, even if the HTML is unchanged. Check the old and fetched documentation versions:

```
git show HEAD:data/bot_api.html | grep -oEm1 'Bot API [0-9]+\.[0-9]+'
grep -oEm1 'Bot API [0-9]+\.[0-9]+' data/bot_api.html
```

Fetch <https://core.telegram.org/bots/api-changelog>. Build a checklist from every release above the changelog baseline, including intermediate and patch releases.

## 2. Parse

```
bundle exec rake parse:types parse:methods
```

On `Parsers::Error`, fix the unsupported markup in the parser, add a regression spec, and retry. Never hand-edit the JSON.

## 3. Rebuild

```
bundle exec rake rebuild:types rebuild:methods
```

Rebuilding overwrites hand-written methods and aliases. Find affected files:

```
git diff -G'^\s*(def|alias) ' --stat -- lib/telegram/bot/types
```

Restore removed methods and aliases from the diff; keep everything else generated.

## 4. Check

```
bundle exec rubocop -a
bundle exec rspec
```

Fix remaining failures. Read new field descriptions for defaults, fixed values and size limits missing from `data/types.json`; unfamiliar wording can escape the parser.

## 5. Verify independently

Delegate verification to an independent, read-only subagent with fresh context. Fill in this self-contained brief:

> Verify Telegram Bot API coverage in the repository at `<absolute repo path>`. Baseline: Bot API `<baseline>` from `CHANGELOG.md` at `<original HEAD>`; target: `<fetched version>`; changed files: `<files>`. Inspect the resulting code and all staged, unstaged and relevant untracked changes. Do not edit or delegate.
>
> Independently fetch <https://core.telegram.org/bots/api-changelog> and read EVERY release numerically above the baseline, including intermediate and patch releases. Do not rely on the parent's checklist. Releases newer than the target mean the update is incomplete.
>
> Verify every item against `data/{types,methods}.json`, `lib/telegram/bot/types`, API dispatch/response handling, parser/rebuild code and specs; consult linked API docs as needed. Cover added, changed and removed types, methods, fields, parameters, return types, defaults, fixed values and constraints. Names and diff stats alone are not evidence.
>
> Return the baseline, versions reviewed and a per-version checklist with file:line evidence for every item: implemented, already supported, not applicable (explain why), missing or uncertain. Include fixes and tests needed for gaps. Failed fetches or incomplete review block verification; never report success for unchecked items.

Fix gaps, rerun step 4, and have the subagent recheck missing or uncertain items. Completion requires every item accounted for and verification passed; report blockers explicitly.

Summarize additions, changes, removals, verified versions and remaining blockers.
