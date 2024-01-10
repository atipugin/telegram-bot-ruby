# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class MessageOriginUser < Base
        attribute :type, Types::String.constrained(eql: 'user').default('user')
        attribute :date, Types::Integer
        attribute :sender_user, User
      end
    end
  end
end
