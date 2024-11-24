# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputMediaAnimation < Base
        attribute :type, Types::String.constrained(eql: 'animation').default('animation')
        attribute :media, Types::String
        attribute? :thumbnail, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :show_caption_above_media, Types::Bool
        attribute? :width, Types::Integer
        attribute? :height, Types::Integer
        attribute? :duration, Types::Integer
        attribute? :has_spoiler, Types::Bool
      end
    end
  end
end
