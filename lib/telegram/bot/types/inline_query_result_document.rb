# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultDocument < Base
        attribute :type, Types::String.constrained(eql: 'document').default('document')
        attribute :id, Types::String
        attribute :title, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute :document_url, Types::String
        attribute :mime_type, Types::String
        attribute? :description, Types::String
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :input_message_content, InputMessageContent
        attribute? :thumbnail_url, Types::String
        attribute? :thumbnail_width, Types::Integer
        attribute? :thumbnail_height, Types::Integer
      end
    end
  end
end
