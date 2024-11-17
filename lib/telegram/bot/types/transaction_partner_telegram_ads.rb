# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TransactionPartnerTelegramAds < Base
        attribute :type, Types::String.constrained(eql: 'telegram_ads').default('telegram_ads')
      end
    end
  end
end
