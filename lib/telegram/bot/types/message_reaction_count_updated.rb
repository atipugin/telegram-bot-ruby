# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class MessageReactionCountUpdated < Base
        attribute :chat, Chat
        attribute :message_id, Types::Integer
        attribute :date, Types::Integer
        attribute :reactions, Types::Array.of(ReactionCount)
      end
    end
  end
end
