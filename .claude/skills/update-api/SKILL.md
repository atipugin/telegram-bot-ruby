---
name: update-api
description: Parse Telegram Bot API docs and rebuild generated Ruby types and endpoints
disable-model-invocation: true
allowed-tools: Bash, Read, Edit, Grep, WebFetch
---

Update generated types and API endpoints from the latest Telegram Bot API documentation.

## Step 1: Check for updates

1. Fetch <https://core.telegram.org/bots/api-changelog> and identify the most recent Bot API version and all version entries listed.
2. Read `CHANGELOG.md` and find the highest Bot API version mentioned to determine which version this lib currently supports.
3. List all Bot API versions that are newer than the lib's current version, with a summary of changes for each.
4. If the lib is already up to date, stop here and inform the user.

## Step 2: Parse

Download the docs once and parse both types and methods from that snapshot:

```
bundle exec rake parse:all
```

`parse:all` is `parse:fetch` (cache the page under `tmp/api.html`) followed by
`parse:types` and `parse:methods`. Re-run `parse:types` / `parse:methods` alone to
re-parse the cached page without hitting the network.

`parse:methods` **aborts** if any documented method's return type cannot be read.
That is a parser bug, not a missing endpoint — a new phrasing has appeared in the
docs and `rakelib/parsers/return_type_rules.rb` needs a rule for it. Do not proceed
with a partial `data/methods.json`.

## Step 3: Rebuild

Before rebuilding, read the custom method files listed in Step 4 so you have a snapshot of their current content.

Regenerate Ruby source files from the parsed JSON data:

```
bundle exec rake rebuild:types
bundle exec rake rebuild:methods
```

## Step 4: Restore custom methods

The rebuild overwrites type files from templates, losing hand-written methods. After rebuild, read each file below and restore the custom method if it's missing:

| File | Method to restore |
|---|---|
| `lib/telegram/bot/types/callback_query.rb` | `def to_s` returning `data.to_s` |
| `lib/telegram/bot/types/message.rb` | `def to_s` returning `text.to_s` |
| `lib/telegram/bot/types/chosen_inline_result.rb` | `alias to_s query` |
| `lib/telegram/bot/types/inline_query.rb` | `alias to_s query` |
| `lib/telegram/bot/types/inline_keyboard_markup.rb` | `def to_compact_hash` that calls `to_compact_hash` on nested `InlineKeyboardButton` items |
| `lib/telegram/bot/types/reply_keyboard_markup.rb` | `def to_compact_hash` that calls `to_compact_hash` on nested `KeyboardButton` items |
| `lib/telegram/bot/types/update.rb` | `def current_message` that finds the first non-`update_id` attribute value |

For each file:

1. Read the current file content
2. Check if the custom method/alias is already present
3. If missing, add it back before the closing `end` of the class, with one blank line before it

## Step 5: Review changes

Run `git diff --stat` and then `git diff` to review all changes. Summarize what was added/modified/removed compared to the previous version.

## Step 6: Lint and test

Run linting and tests to verify everything is correct:

```
bundle exec rubocop
bundle exec rake spec
```

If rubocop or tests fail, fix the issues before finishing.

## Step 7: Verify the parser did not drift

When the intent is *only* to pick up a new Bot API version, the parser changes in
`data/` should be exactly the documented additions. If a re-parse of an unchanged
docs page produces any diff at all, the parser has drifted and that must be
understood before shipping:

```
bundle exec rake parse:all
git diff data/
```

This is the regression test for `rakelib/docs/` and `rakelib/parsers/`; it needs
network, so it is not part of CI.
