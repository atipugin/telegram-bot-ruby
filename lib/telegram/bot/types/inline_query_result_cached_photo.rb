module Telegram
  module Bot
    module Types
      class InlineQueryResultCachedPhoto < Base
        attribute :type, String, default: 'photo'
        attribute :id, String
        attribute :photo_file_id, String
        attribute :title, String
        attribute :description, String
        attribute :caption, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
