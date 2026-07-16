# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TransactionPartnerChat < Base
        attribute :type, Types::String.constrained(eql: 'chat').default('chat')
        attribute :chat, Chat
        attribute? :gift, Gift
      end
    end
  end
end
