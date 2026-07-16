# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputTextMessageContent < Base
        attribute :message_text, Types::String.constrained(min_size: 1, max_size: 4096)
        attribute? :parse_mode, Types::String
        attribute? :entities, Types::Array.of(MessageEntity)
        attribute? :link_preview_options, LinkPreviewOptions
      end
    end
  end
end
