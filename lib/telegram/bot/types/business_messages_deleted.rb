# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BusinessMessagesDeleted < Base
        attribute :business_connection_id, Types::String
        attribute :chat, Chat
        attribute :message_ids, Types::Array.of(Types::Integer)
      end
    end
  end
end
