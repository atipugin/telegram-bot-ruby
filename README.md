# telegram-bot-ruby

Ruby wrapper for [Telegram's Bot API](https://core.telegram.org/bots/api).

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
    when /^hello/
      bot.api.sendMessage(chat_id: message.chat.id, text: "Hello, #{message.from.username}")
    end
  end
end
```

Note that `bot.api` object implements [Telegram Bot API methods](https://core.telegram.org/bots/api#available-methods) as is. So you can invoke any method inside the block without any problems.

Same thing about `message` object - it implements [Message](https://core.telegram.org/bots/api#message) spec, so you always know what to expect from it.

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
