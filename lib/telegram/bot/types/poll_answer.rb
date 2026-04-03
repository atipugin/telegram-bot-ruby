# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PollAnswer < Base
        attribute :poll_id, Types::String
        attribute? :voter_chat, Chat
        attribute? :user, User
        attribute :option_ids, Types::Array.of(Types::Integer)
        attribute :option_persistent_ids, Types::Array.of(Types::String)
      end
    end
  end
end
