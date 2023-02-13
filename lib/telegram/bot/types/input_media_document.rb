# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputMediaDocument < Base
        attribute :type, Types::String.default('document')
        attribute :media, Types::String
        attribute? :thumb, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :disable_content_type_detection, Types::Bool
      end
    end
  end
end
