# frozen_string_literal: true

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
        attribute :thumb_mime_type, String
        attribute :title, String
        attribute :caption, String
        attribute :parse_mode, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
