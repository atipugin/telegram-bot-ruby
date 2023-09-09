# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputMediaPhoto < Base
        attribute :type, Types::String.constrained(eql: 'photo').default('photo')
        attribute :media, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :has_spoiler, Types::Bool
      end
    end
  end
end
