module Telegram
  module Bot
    module Types
      class InlineQueryResultCachedSticker < Base
        attribute :type, String, default: 'sticker'
        attribute :id, String
        attribute :sticker_file_id, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
