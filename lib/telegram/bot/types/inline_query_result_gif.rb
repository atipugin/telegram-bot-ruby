module Telegram
  module Bot
    module Types
      class InlineQueryResultGif < Base
        attribute :type, String, default: 'gif'
        attribute :id, String
        attribute :gif_url, String
        attribute :gif_width, Integer
        attribute :gif_height, Integer
        attribute :thumb_url, String
        attribute :title, String
        attribute :caption, String
        attribute :message_text, String
        attribute :parse_mode, String
        attribute :disable_web_page_preview, Boolean
      end
    end
  end
end
