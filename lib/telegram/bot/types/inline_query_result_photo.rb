module Telegram
  module Bot
    module Types
      class InlineQueryResultPhoto < Base
        attribute :type, String, default: 'photo'
        attribute :id, String
        attribute :photo_url, String
        attribute :photo_width, Integer
        attribute :photo_height, Integer
        attribute :thumb_url, String
        attribute :title, String
        attribute :description, String
        attribute :caption, String
        attribute :message_text, String
        attribute :parse_mode, String
        attribute :disable_web_page_preview, Boolean
      end
    end
  end
end
