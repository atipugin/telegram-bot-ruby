# telegram-bot-ruby

Ruby wrapper for [Telegram's Bot API](https://core.telegram.org/bots/api).

[![Gem Version](https://badge.fury.io/rb/telegram-bot-ruby.svg)](http://badge.fury.io/rb/telegram-bot-ruby)
[![Build Status](https://github.com/atipugin/telegram-bot-ruby/actions/workflows/ci.yml/badge.svg)](https://github.com/atipugin/telegram-bot-ruby/actions)
[![Maintainability](https://api.codeclimate.com/v1/badges/7e61fbf5bec86e118fb1/maintainability)](https://codeclimate.com/github/atipugin/telegram-bot-ruby/maintainability)
[![Say Thanks!](https://img.shields.io/badge/Say%20Thanks!-🦉-1EAEDB.svg)](https://saythanks.io/to/atipugin)

## 🚧 Upgrading to 1.0

Since v1.0 `telegram-bot-ruby` uses [`dry-struct`](https://github.com/dry-rb/dry-struct)
instead of [`virtus`](https://github.com/solnic/virtus).
This means that type objects are now immutable and you can't change them after initialization:

```ruby
# This won't work
kb = Telegram::Bot::Types::ReplyKeyboardRemove.new
kb.remove_keyboard = true

# You have to set attributes in constructor instead
kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
```

Please make sure it doesn't break your existing code before upgrading to 1.0.

## Installation

Add following line to your Gemfile:

```ruby
gem 'telegram-bot-ruby', '~> 2.1'
```

And then execute:

```shell
bundle
```

Or install it system-wide:

```shell
gem install telegram-bot-ruby
```

## Usage

First things first, you need to [obtain a token](https://core.telegram.org/bots#6-botfather) for your bot.
Then create your Telegram bot like this:

```ruby
require 'telegram/bot'

token = 'YOUR_TELEGRAM_BOT_API_TOKEN'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end
```

Note that `bot.api` object implements
[Telegram Bot API methods](https://core.telegram.org/bots/api#available-methods) as is.
So you can invoke any method inside the block without any problems.
All methods are available in both *snake_case* and *camelCase* notations.

If you need to start a bot in development mode you have to pass `environment: :test`:

```ruby
Telegram::Bot::Client.run(token, environment: :test) do |bot|
  # ...
end
```

Same thing about `message` object: it implements [Message](https://core.telegram.org/bots/api#message) spec,
so you always know what to expect from it.

To gracefully stop the bot, for example by `INT` signal (Ctrl-C), call the `bot.stop` method:

```ruby
bot = Telegram::Bot::Client.new(token)

Signal.trap('INT') do
  bot.stop
end

bot.listen do |message|
  # it will be in an infinity loop until `bot.stop` command
  # (with a small delay for the current `fetch_updates` request)
end
```

## Webhooks

If you are going to use [webhooks](https://core.telegram.org/bots/api#setwebhook)
instead of [long polling](https://core.telegram.org/bots/api#getupdates),
you need to implement your own webhook callbacks server.
Take a look at [this repo](https://github.com/solyaris/BOTServer) as an example.

## Proxy

As some countries block access to Telegram, you can set up your own proxy and use it to access Telegram API.
In this case you need to configure API URL:

```ruby
Telegram::Bot::Client.run(token, url: 'https://proxy.example.com') do |bot|
  # ...
end
```

## Custom keyboards

You can use your own [custom keyboards](https://core.telegram.org/bots#keyboards).
Here is an example:

```ruby
bot.listen do |message|
  case message.text
  when '/start'
    question = 'London is a capital of which country?'
    # See more: https://core.telegram.org/bots/api#replykeyboardmarkup
    answers =
        Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: [
            [{ text: 'A' }, { text: 'B' }],
            [{ text: 'C' }, { text: 'D' }]
          ],
          one_time_keyboard: true
        )
    bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
  when '/stop'
    # See more: https://core.telegram.org/bots/api#replykeyboardremove
    kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
    bot.api.send_message(chat_id: message.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)
  end
end
```

Furthermore, you can ask user to share location or phone number using `KeyboardButton`:

```ruby
bot.listen do |message|
  kb = [[
    Telegram::Bot::Types::KeyboardButton.new(text: 'Give me your phone number', request_contact: true),
    Telegram::Bot::Types::KeyboardButton.new(text: 'Show me your location', request_location: true)
  ]]
  markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
  bot.api.send_message(chat_id: message.chat.id, text: 'Hey!', reply_markup: markup)
end
```

## Inline keyboards

[Bot API 2.0](https://core.telegram.org/bots/2-0-intro) brought us new inline keyboards.
Example:

```ruby
bot.listen do |message|
  case message
  when Telegram::Bot::Types::CallbackQuery
    # Here you can handle your callbacks from inline buttons
    if message.data == 'touch'
      bot.api.send_message(chat_id: message.from.id, text: "Don't touch me!")
    end
  when Telegram::Bot::Types::Message
    kb = [[
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Go to Google', url: 'https://google.com'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Touch me', callback_data: 'touch'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Switch to inline', switch_inline_query: 'some text')
    ]]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    bot.api.send_message(chat_id: message.chat.id, text: 'Make a choice', reply_markup: markup)
  end
end
```

## Inline bots

If you are going to create [inline bot](https://core.telegram.org/bots/inline), check the example below:

```ruby
bot.listen do |message|
  case message
  when Telegram::Bot::Types::InlineQuery
    results = [
      ['1', 'First article', 'Very interesting text goes here.'],
      ['2', 'Second article', 'Another interesting text here.']
    ].map do |arr|
      Telegram::Bot::Types::InlineQueryResultArticle.new(
        id: arr[0],
        title: arr[1],
        input_message_content: Telegram::Bot::Types::InputTextMessageContent.new(message_text: arr[2])
      )
    end

    bot.api.answer_inline_query(inline_query_id: message.id, results: results)
  when Telegram::Bot::Types::Message
    bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!")
  end
end
```

Now, with `inline` mode enabled, your `message` object can be an instance of
[Message](https://core.telegram.org/bots/api#message),
[InlineQuery](https://core.telegram.org/bots/api#inlinequery) or
[ChosenInlineResult](https://core.telegram.org/bots/api#choseninlineresult).
That's why you need to check type of each message and decide how to handle it.

Using `answer_inline_query` you can send query results to user.
`results` field must be an array of [query result objects](https://core.telegram.org/bots/api#inlinequeryresult).

## File upload

Your bot can even upload files
([photos](https://core.telegram.org/bots/api#sendphoto),
[audio](https://core.telegram.org/bots/api#sendaudio),
[documents](https://core.telegram.org/bots/api#senddocument),
[stickers](https://core.telegram.org/bots/api#sendsticker),
[video](https://core.telegram.org/bots/api#sendvideo))
to Telegram servers.
Just like this:

```ruby
bot.listen do |message|
  case message.text
  when '/photo'
    path_to_photo = File.expand_path('~/Desktop/jennifer.jpg')
    bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new(path_to_photo, 'image/jpeg'))
  end
end
```

## Logging

By default, bot doesn't log anything (uses `NullLoger`).
You can change this behavior and provide your own logger class.
See example below:

```ruby
Telegram::Bot::Client.run(token, logger: Logger.new($stderr)) do |bot|
  bot.logger.info('Bot has been started')
  bot.listen do |message|
    # ...
  end
end
```

## Connection adapters

Since version `0.5.0` we rely on [faraday](https://github.com/lostisland/faraday) under the hood.
You can use any of supported adapters (for example, `net/http/persistent`):

```ruby
require 'net/http/persistent'

Telegram::Bot.configure do |config|
  config.adapter = :net_http_persistent
end
```

## Boilerplates

If you don't know how to setup database for your bot or how to use it with different languages
here are some boilerplates which can help you to start faster:

- [Ruby Telegram Bot boilerplate](https://github.com/telegram-bots/ruby-telegram-bot-boilerplate)

## Contributing

1. Fork it.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create a new Pull Request.
