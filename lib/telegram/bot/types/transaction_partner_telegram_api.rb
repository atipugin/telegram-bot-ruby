# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TransactionPartnerTelegramApi < Base
        attribute :type, Types::String.constrained(eql: 'telegram_api').default('telegram_api')
        attribute :request_count, Types::Integer
      end
    end
  end
end
