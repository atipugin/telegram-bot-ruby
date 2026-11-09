---
name: update-api
description: Update the generated types and endpoints to the latest Telegram Bot API
disable-model-invocation: true
allowed-tools: Bash, Read, Edit, Grep, WebFetch
---

Update the gem to the latest Telegram Bot API. `rakelib/README.md` explains how the parser works and where to fix it when it fails.

## 1. Fetch the docs

```
bundle exec rake docs:fetch
```

If `git status --short data/bot_api.html` prints nothing, the gem is up to date. Say so and stop.

Otherwise, find the version before and after:

```
git show HEAD:data/bot_api.html | grep -oEm1 'Bot API [0-9]+\.[0-9]+'
grep -oEm1 'Bot API [0-9]+\.[0-9]+' data/bot_api.html
```

Fetch <https://core.telegram.org/bots/api-changelog> and list what changed in every version after the old one.

## 2. Parse

```
bundle exec rake parse:types parse:methods
```

If this raises `Parsers::Error`, the page has markup the parser does not know. Fix the parser, add a spec for the new case, and run the step again. Never edit the JSON files by hand.

## 3. Rebuild

```
bundle exec rake rebuild:types rebuild:methods
```

This overwrites every type file, and a few of them contain hand-written code. List those:

```
git diff -G'^\s*(def|alias) ' --stat -- lib/telegram/bot/types
```

In each listed file, put back the methods and aliases that `git diff` shows as removed. Keep everything else as generated.

## 4. Check

```
bundle exec rubocop -a
bundle exec rspec
```

Fix whatever is left.

Then compare `git diff --stat -- data lib` with the changelog from step 1. Every type, method and field it mentions should be in the diff. The parser does not notice a constraint that is worded in a new way, so read the descriptions of new fields for defaults, fixed values and size limits that are missing from `data/types.json`.

Finish with a summary of what was added, changed and removed.
