module Telegram
  module Bot
    module Types
      class InlineQueryResultGif < Base
        attribute :type, String, default: 'gif'
        attribute :id, String
        attribute :gif_url, String
        attribute :gif_width, Integer
        attribute :gif_height, Integer
        attribute :gif_duration, Integer
        attribute :thumb_url, String
        attribute :title, String
        attribute :caption, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
