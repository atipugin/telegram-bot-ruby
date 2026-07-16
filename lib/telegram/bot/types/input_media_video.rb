# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputMediaVideo < Base
        attribute :type, Types::String.constrained(eql: 'video').default('video')
        attribute :media, Types::String
        attribute? :thumbnail, Types::String
        attribute? :cover, Types::String
        attribute? :start_timestamp, Types::Integer
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :show_caption_above_media, Types::Bool
        attribute? :width, Types::Integer
        attribute? :height, Types::Integer
        attribute? :duration, Types::Integer
        attribute? :supports_streaming, Types::Bool
        attribute? :has_spoiler, Types::Bool
      end
    end
  end
end
