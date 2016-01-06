module Telegram
  module Bot
    module Types
      class InlineQueryResultArticle < Base
        attribute :type, String, default: 'article'
        attribute :id, String
        attribute :title, String
        attribute :message_text, String
        attribute :parse_mode, String
        attribute :parse_mode, String
        attribute :disable_web_page_preview, Boolean
        attribute :url, String
        attribute :hide_url, Boolean
        attribute :description, String
        attribute :thumb_url, String
        attribute :thumb_width, Integer
        attribute :thumb_height, Integer
      end
    end
  end
end
