# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatBoostSourceGiftCode < Base
        attribute :source, Types::String.constrained(eql: 'gift_code').default('gift_code')
        attribute :user, User
      end
    end
  end
end
