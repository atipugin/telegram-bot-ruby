# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ## Just for classes consistency
      # rubocop:disable Naming/ConstantName
      TransactionPartner = (
        TransactionPartnerUser |
        TransactionPartnerFragment |
        TransactionPartnerTelegramAds |
        TransactionPartnerOther
      )
      # rubocop:enable Naming/ConstantName
    end
  end
end