module Telegram
  module Bot
    module Types
      class InlineQueryResultContact < Base
        attribute :type, String, default: 'location'
        attribute :id, String
        attribute :phone_number, String
        attribute :first_name, String
        attribute :last_name, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
        attribute :thumb_url, String
        attribute :thumb_width, Integer
        attribute :thumb_height, Integer
      end
    end
  end
end
