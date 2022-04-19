# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultArticle < Base
        attribute :type, String, default: 'article'
        attribute :id, String
        attribute :title, String
        attribute :input_message_content, InputMessageContent
        attribute :reply_markup, InlineKeyboardMarkup
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
