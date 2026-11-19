# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TextQuote < Base
        attribute :text, Types::String
        attribute? :entities, Types::Array.of(MessageEntity)
        attribute? :rich_texts, Types::Array.of(RichText)
        attribute :position, Types::Integer
        attribute? :is_manual, Types::True
      end
    end
  end
end
