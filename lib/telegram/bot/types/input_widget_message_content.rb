# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputWidgetMessageContent < Base
        attribute :html, Types::String
        attribute? :width, Types::Integer
        attribute? :height, Types::Integer
        attribute? :public_data, Types::String
        attribute? :chat_data, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :show_caption_above_media, Types::Bool
        attribute? :allow_queries, Types::Bool
        attribute? :is_shared, Types::Bool
      end
    end
  end
end
