# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatBoostSourcePremium < Base
        attribute :source, Types::String.constrained(eql: 'premium').default('premium')
        attribute :user, User
      end
    end
  end
end
