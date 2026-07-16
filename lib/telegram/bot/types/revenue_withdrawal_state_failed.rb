# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RevenueWithdrawalStateFailed < Base
        attribute :type, Types::String.constrained(eql: 'failed').default('failed')
      end
    end
  end
end
