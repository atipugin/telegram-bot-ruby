# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class MessageOriginHiddenUser < Base
        attribute :type, Types::String.constrained(eql: 'hidden_user').default('hidden_user')
        attribute :date, Types::Integer
        attribute :sender_user_name, Types::String
      end
    end
  end
end
