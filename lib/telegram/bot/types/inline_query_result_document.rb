# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultDocument < Base
        attribute :type, Types::String.default('document')
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
        attribute? :thumb_url, Types::String
        attribute? :thumb_width, Types::Integer
        attribute? :thumb_height, Types::Integer
      end
    end
  end
end
