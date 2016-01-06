module Telegram
  module Bot
    module Types
      class InlineQueryResultVideo < Base
        attribute :type, String, default: 'video'
        attribute :id, String
        attribute :video_url, String
        attribute :mime_type, String
        attribute :message_text, String
        attribute :parse_mode, String
        attribute :disable_web_page_preview, Boolean
        attribute :video_width, Integer
        attribute :video_height, Integer
        attribute :video_duration, Integer
        attribute :thumb_url, String
        attribute :title, String
        attribute :description, String
      end
    end
  end
end
