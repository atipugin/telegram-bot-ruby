module Telegram
  module Bot
    module Types
      class InlineQueryResultCachedVideo < Base
        attribute :type, String, default: 'video'
        attribute :id, String
        attribute :video_file_id, String
        attribute :title, String
        attribute :description, String
        attribute :caption, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
