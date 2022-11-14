# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputTextMessageContent < InputMessageContent
        attribute :message_text, Types::String
        attribute? :parse_mode, Types::String
        attribute? :entities, Types::Array.of(MessageEntity)
        attribute? :disable_web_page_preview, Types::Bool
      end
    end
  end
end
