# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ## Just for classes consistency
      # rubocop:disable Naming/ConstantName
      RevenueWithdrawalState = (
        RevenueWithdrawalStatePending |
        RevenueWithdrawalStateSucceeded |
        RevenueWithdrawalStateFailed
      )
      # rubocop:enable Naming/ConstantName
    end
  end
end
