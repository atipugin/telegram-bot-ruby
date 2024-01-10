# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class MessageReactionUpdated < Base
        attribute :chat, Chat
        attribute :message_id, Types::Integer
        attribute? :user, User
        attribute? :actor_chat, Chat
        attribute :date, Types::Integer
        attribute :old_reaction, Types::Array.of(ReactionType)
        attribute :new_reaction, Types::Array.of(ReactionType)
      end
    end
  end
end
