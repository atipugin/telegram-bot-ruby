require 'rubygems'
require 'telegram/bot'

token = 'replace-me-with-your-real-token'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.sendMessage(chat_id: message.chat.id, text: "Hello, #{message.from.username}!")
    when '/end'
      bot.api.sendMessage(chat_id: message.chat.id, text: "Bye, #{message.from.username}!")
    else
      bot.api.sendMessage(chat_id: message.chat.id, text: "I don't understand you :(")
    end
  end
end
