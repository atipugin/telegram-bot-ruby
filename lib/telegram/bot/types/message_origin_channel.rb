# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class MessageOriginChannel < Base
        attribute :type, Types::String.constrained(eql: 'channel').default('channel')
        attribute :date, Types::Integer
        attribute :chat, Chat
        attribute :message_id, Types::Integer
        attribute? :author_signature, Types::String
      end
    end
  end
end
