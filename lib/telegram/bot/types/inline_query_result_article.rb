# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultArticle < Base
        attribute :type, Types::String.default('article')
        attribute :id, Types::String
        attribute :title, Types::String
        attribute :input_message_content, InputMessageContent
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :url, Types::String
        attribute? :hide_url, Types::Bool
        attribute? :description, Types::String
        attribute? :thumb_url, Types::String
        attribute? :thumb_width, Types::Integer
        attribute? :thumb_height, Types::Integer
      end
    end
  end
end
