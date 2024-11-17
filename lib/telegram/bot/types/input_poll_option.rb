# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputPollOption < Base
        attribute :text, Types::String.constrained(min_size: 1, max_size: 100)
        attribute? :text_parse_mode, Types::String
        attribute? :text_entities, Types::Array.of(MessageEntity)
      end
    end
  end
end
