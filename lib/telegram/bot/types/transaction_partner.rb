# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ## Just for classes consistency
      # rubocop:disable Naming/ConstantName
      TransactionPartner = (
        TransactionPartnerUser |
        TransactionPartnerChat |
        TransactionPartnerAffiliateProgram |
        TransactionPartnerFragment |
        TransactionPartnerTelegramAds |
        TransactionPartnerTelegramApi |
        TransactionPartnerOther
      )
      # rubocop:enable Naming/ConstantName
    end
  end
end
