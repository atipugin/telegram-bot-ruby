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

Run both parse tasks to scrape the latest Telegram Bot API docs:

```
bundle exec rake parse:types
bundle exec rake parse:methods
```

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
