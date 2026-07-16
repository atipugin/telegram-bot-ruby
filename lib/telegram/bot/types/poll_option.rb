# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PollOption < Base
        attribute :persistent_id, Types::String
        attribute :text, Types::String.constrained(min_size: 1, max_size: 100)
        attribute? :text_entities, Types::Array.of(MessageEntity)
        attribute :voter_count, Types::Integer
        attribute? :added_by_user, User
        attribute? :added_by_chat, Chat
        attribute? :addition_date, Types::Integer
      end
    end
  end
end
