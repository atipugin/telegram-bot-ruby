# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultArticle < Base
        attribute :type, Types::String.constrained(eql: 'article').default('article')
        attribute :id, Types::String
        attribute :title, Types::String
        attribute :input_message_content, InputMessageContent
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :url, Types::String
        attribute? :description, Types::String
        attribute? :thumbnail_url, Types::String
        attribute? :thumbnail_width, Types::Integer
        attribute? :thumbnail_height, Types::Integer
      end
    end
  end
end
