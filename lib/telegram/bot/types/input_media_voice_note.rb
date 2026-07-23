# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputMediaVoiceNote < Base
        attribute :type, Types::String.constrained(eql: 'voice_note').default('voice_note')
        attribute :media, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :duration, Types::Integer
      end
    end
  end
end
