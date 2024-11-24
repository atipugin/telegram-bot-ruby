# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RevenueWithdrawalStateSucceeded < Base
        attribute :type, Types::String.constrained(eql: 'succeeded').default('succeeded')
        attribute :date, Types::Integer
        attribute :url, Types::String
      end
    end
  end
end
