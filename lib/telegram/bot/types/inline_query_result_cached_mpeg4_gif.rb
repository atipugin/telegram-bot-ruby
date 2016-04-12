module Telegram
  module Bot
    module Types
      class InlineQueryResultCachedMpeg4Gif < Base
        attribute :type, String, default: 'mpeg4_gif'
        attribute :id, String
        attribute :mpeg4_file_id, String
        attribute :title, String
        attribute :caption, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
