module Telegram
  module Bot
    module Types
      class InlineQueryResultCachedGif < Base
        attribute :type, String, default: 'gif'
        attribute :id, String
        attribute :gif_file_id, String
        attribute :title, String
        attribute :caption, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
