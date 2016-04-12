module Telegram
  module Bot
    module Types
      class InlineQueryResultPhoto < Base
        attribute :type, String, default: 'photo'
        attribute :id, String
        attribute :photo_url, String
        attribute :thumb_url, String
        attribute :photo_width, Integer
        attribute :photo_height, Integer
        attribute :title, String
        attribute :description, String
        attribute :caption, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
