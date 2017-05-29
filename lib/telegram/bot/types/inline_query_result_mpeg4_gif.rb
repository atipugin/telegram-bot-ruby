module Telegram
  module Bot
    module Types
      class InlineQueryResultMpeg4Gif < Base
        attribute :type, String, default: 'mpeg4_gif'
        attribute :id, String
        attribute :mpeg4_url, String
        attribute :mpeg4_width, Integer
        attribute :mpeg4_height, Integer
        attribute :mpeg4_duration, Integer
        attribute :thumb_url, String
        attribute :title, String
        attribute :caption, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
