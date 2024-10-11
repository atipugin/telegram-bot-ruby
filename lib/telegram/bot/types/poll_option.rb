# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PollOption < Base
        attribute :text, Types::String
        attribute? :text_entities, Types::Array.of(MessageEntity)
        attribute :voter_count, Types::Integer
      end
    end
  end
end
