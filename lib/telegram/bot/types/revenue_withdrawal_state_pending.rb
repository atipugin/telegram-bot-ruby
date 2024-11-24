# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RevenueWithdrawalStatePending < Base
        attribute :type, Types::String.constrained(eql: 'pending').default('pending')
      end
    end
  end
end
