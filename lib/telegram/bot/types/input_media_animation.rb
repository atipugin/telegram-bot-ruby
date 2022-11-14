# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputMediaAnimation < Base
        attribute :type, Types::String.default('animation')
        attribute :media, Types::String
        attribute? :thumb, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :width, Types::Integer
        attribute? :height, Types::Integer
        attribute? :duration, Types::Integer
      end
    end
  end
end
