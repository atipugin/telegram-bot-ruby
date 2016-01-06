# telegram-bot-ruby

Ruby wrapper for [Telegram's Bot API](https://core.telegram.org/bots/api).

[![Gem Version](https://badge.fury.io/rb/telegram-bot-ruby.svg)](http://badge.fury.io/rb/telegram-bot-ruby)
[![Code Climate](https://codeclimate.com/github/atipugin/telegram-bot-ruby/badges/gpa.svg)](https://codeclimate.com/github/atipugin/telegram-bot-ruby)

## Installation

Add following line to your Gemfile:

```ruby
gem 'telegram-bot-ruby'
```

And then execute:

```shell
$ bundle
```

Or install it system-wide:

```shell
$ gem install telegram-bot-ruby
```

## Usage

First things first, you need to [obtain a token](https://core.telegram.org/bots#botfather) for your bot. Then create your Telegram bot like this:

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

Note that `bot.api` object implements [Telegram Bot API methods](https://core.telegram.org/bots/api#available-methods) as is. So you can invoke any method inside the block without any problems. All methods are available in both *snake_case* and *camelCase* notations.

Same thing about `message` object - it implements [Message](https://core.telegram.org/bots/api#message) spec, so you always know what to expect from it.

## Webhooks

If you are going to use [webhooks](https://core.telegram.org/bots/api#setwebhook) instead of [long polling](https://core.telegram.org/bots/api#getupdates), you need to implement your own webhook callbacks server. Take a look at [this repo](https://github.com/solyaris/BOTServer) as an example.

## Custom keyboards

You can use your own [custom keyboards](https://core.telegram.org/bots#keyboards). Here is an example:

```ruby
bot.listen do |message|
  case message.text
  when '/start'
    question = 'London is a capital of which country?'
    # See more: https://core.telegram.org/bots/api#replykeyboardmarkup
    answers =
      Telegram::Bot::Types::ReplyKeyboardMarkup
      .new(keyboard: [%w(A B), %w(C D)], one_time_keyboard: true)
    bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
  when '/stop'
    # See more: https://core.telegram.org/bots/api#replykeyboardhide
    kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
    bot.api.send_message(chat_id: message.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)
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
      Telegram::Bot::Types::InlineQueryResultArticle
        .new(id: 1, title: 'First article', message_text: 'Very interesting text goes here.'),
      Telegram::Bot::Types::InlineQueryResultArticle
        .new(id: 2, title: 'Second article', message_text: 'Another interesting text here.')
    ]
    bot.api.answer_inline_query(inline_query_id: message.id, results: results)
  when Telegram::Bot::Types::Message
    bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!")
  end
end
```

Now, with `inline` mode enabled, your `message` object can be an instance of [Message](https://core.telegram.org/bots/api#message), [InlineQuery](https://core.telegram.org/bots/api#inlinequery) or [ChosenInlineResult](https://core.telegram.org/bots/api#choseninlineresult). That's why you need to check type of each message and decide how to handle it.

Using `answer_inline_query` you can send query results to user. `results` field must be an array of [query result objects](https://core.telegram.org/bots/api#inlinequeryresult).

## File upload

Your bot can even upload files ([photos](https://core.telegram.org/bots/api#sendphoto), [audio](https://core.telegram.org/bots/api#sendaudio), [documents](https://core.telegram.org/bots/api#senddocument), [stickers](https://core.telegram.org/bots/api#sendsticker), [video](https://core.telegram.org/bots/api#sendvideo)) to Telegram servers. Just like this:

```ruby
bot.listen do |message|
  case message.text
  when '/photo'
    bot.api.send_photo(chat_id: message.chat.id, photo: File.new('~/Desktop/jennifer.jpg'))
  end
end
```

## Logging

By default, bot doesn't log anything (uses `NullLoger`). You can change this behavior and provide your own logger class. See example below:

```ruby
Telegram::Bot::Client.run(token, logger: Logger.new($stdout)) do |bot|
  bot.logger.info('Bot has been started')
  bot.listen do |message|
    # ...
  end
end
```

## Botan.io support

Gem provides support of [Botan.io](http://botan.io/) analytics out of box. All you need is to obtain a token (follow the instructions from https://github.com/botanio/sdk). To track events you're interested in just call `#track` method. See example below:

```ruby
require 'telegram/bot'
require 'telegram/bot/botan' # Botan.io extension isn't loaded by default, so make sure you required it.

token = 'YOUR_TELEGRAM_BOT_API_TOKEN'

Telegram::Bot::Client.run(token) do |bot|
  bot.enable_botan!('YOUR_BOTAN_TOKEN')
  bot.listen do |message|
    case message.text
    when '/start'
      bot.track('Started', message.from.id, type_of_chat: message.chat.class.name)
      # ...
    end
  end
end
```

`#track` method accepts 3 arguments:
- name of event (required)
- Telegram's user id (required)
- hash of additional properties (optional)

## Connection pool size

Sometimes you need to do some heavy work in another thread and send response from there. In this case you have to increase your connection pool size (by default it's *1*). You can do it by setting env variable `TELEGRAM_BOT_POOL_SIZE`:

```shell
$ TELEGRAM_BOT_POOL_SIZE=4 ruby bot.rb
```

## Boilerplates

If you don't know how to setup database for your bot or how to use it with different languages here are some boilerplates which can help you to start faster:
- [Ruby Telegram Bot boilerplate](https://github.com/telegram-bots/ruby-telegram-bot-boilerplate)

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
