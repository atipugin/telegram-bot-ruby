# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class MessageOriginChat < Base
        attribute :type, Types::String.constrained(eql: 'chat').default('chat')
        attribute :date, Types::Integer
        attribute :sender_chat, Chat
        attribute? :author_signature, Types::String
      end
    end
  end
end
