# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TransactionPartnerFragment < Base
        attribute :type, Types::String.constrained(eql: 'fragment').default('fragment')
        attribute? :withdrawal_state, RevenueWithdrawalState
      end
    end
  end
end
