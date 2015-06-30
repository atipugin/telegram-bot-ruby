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
    when /^\/start$/
      bot.api.sendMessage(chat_id: message.chat.id, text: "Hello, #{message.from.username}")
    when /^\/stop$/
      bot.api.sendMessage(chat_id: message.chat.id, text: "Bye, #{message.from.username}")
    end
  end
end
```

Note that `bot.api` object implements [Telegram Bot API methods](https://core.telegram.org/bots/api#available-methods) as is. So you can invoke any method inside the block without any problems.

Same thing about `message` object - it implements [Message](https://core.telegram.org/bots/api#message) spec, so you always know what to expect from it.

## Custom keyboards

You can use your own [custom keyboards](https://core.telegram.org/bots#keyboards). Here is an example:

```ruby
bot.listen do |message|
  case message.text
  when /^\/start$/
    question = 'London is a capital of which country?'
    # See more: https://core.telegram.org/bots/api#replykeyboardmarkup
    answers =
      Telegram::Bot::Types::ReplyKeyboardMarkup
      .new(keyboard: [%w(A B), %w(C D)], one_time_keyboard: true)
    bot.api.sendMessage(chat_id: message.chat.id, text: question, reply_markup: answers)
  when /^\/stop$/
    # See more: https://core.telegram.org/bots/api#replykeyboardhide
    kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
    bot.api.sendMessage(chat_id: message.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)
  end
end
```

## File upload

Your bot can even upload files to Telegram servers (i.e. https://core.telegram.org/bots/api#sendphoto). Just like this:

```ruby
bot.listen do |message|
  case message.text
  when /^\/photo$/
    bot.api.sendPhoto(chat_id: message.chat.id, photo: File.new('~/Desktop/jennifer.jpg'))
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
