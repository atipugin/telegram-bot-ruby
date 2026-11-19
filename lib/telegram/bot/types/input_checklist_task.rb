# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputChecklistTask < Base
        attribute :id, Types::Integer
        attribute :text, Types::String
        attribute? :parse_mode, Types::String
        attribute? :text_entities, Types::Array.of(MessageEntity)
      end
    end
  end
end
