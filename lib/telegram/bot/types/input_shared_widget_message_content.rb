# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputSharedWidgetMessageContent < Base
        attribute :widget_id, Types::String
        attribute? :chat_data, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :show_caption_above_media, Types::Bool
      end
    end
  end
end
