# telegram-bot

Ruby wrapper for [Telegram's Bot API](https://core.telegram.org/bots/api).

## Installation

Add following line to your Gemfile:

```ruby
gem 'telegram-bot', github: 'atipugin/telegram-bot'
```

And then execute:

```shell
$ bundle
```

## Usage

First things first, you need to [obtain a token](https://core.telegram.org/bots#botfather) for your bot. Then create your Telegram bot like this:

```ruby
token = 'YOUR_TELEGRAM_BOT_API_TOKEN'

Telegram::Bot::Runner.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when /^hello/
      bot.api.sendMessage(chat_id: message.chat.id, text: "Hello, #{message.from.username}")
    end
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
