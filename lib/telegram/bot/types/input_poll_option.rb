# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputPollOption < Base
        attribute :text, Types::String
        attribute? :text_parse_mode, Types::String
        attribute? :text_entities, Types::Array.of(MessageEntity)
      end
    end
  end
end
