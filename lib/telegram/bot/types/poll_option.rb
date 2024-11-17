# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PollOption < Base
        attribute :text, Types::String.constrained(min_size: 1, max_size: 100)
        attribute? :text_entities, Types::Array.of(MessageEntity)
        attribute :voter_count, Types::Integer
      end
    end
  end
end
