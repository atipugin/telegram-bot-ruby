# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultVideo < Base
        attribute :type, String, default: 'video'
        attribute :id, String
        attribute :video_url, String
        attribute :mime_type, String
        attribute :thumb_url, String
        attribute :title, String
        attribute :caption, String
        attribute :parse_mode, String
        attribute :video_width, Integer
        attribute :video_height, Integer
        attribute :video_duration, Integer
        attribute :description, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
