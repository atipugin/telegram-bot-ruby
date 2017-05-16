require 'rubygems'
require 'telegram/bot'

token = 'replace-me-with-your-real-token'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!")
    when '/end'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}!")
    when '/show_my_photo'
      profile_photos = message.from.profile_photos(bot.api)
      if profile_photos.total_count > 0
        file = profile_photos.photos[0].get_file(bot.api)
        #Sending photo by file_id
        #bot.api.sendPhoto(chat_id: message.chat.id, photo: profile_photos.photos[0].file_id)
        File.open("/tmp/#{profile_photos.photos[0].file_id}", 'wb') { |f| f.write(file) }
        bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new("/tmp/#{profile_photos.photos[0].file_id}", 'image/jpeg'))
      else
        bot.api.send_message(chat_id: message.chat.id, text: 'Go to settings to update your photo :(')
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: "I don't understand you :(")
    end
  end
end
