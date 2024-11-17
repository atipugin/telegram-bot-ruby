# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RefundedPayment < Base
        attribute :currency, Types::String.constrained(eql: 'XTR').default('XTR')
        attribute :total_amount, Types::Integer
        attribute :invoice_payload, Types::String
        attribute :telegram_payment_charge_id, Types::String
        attribute? :provider_payment_charge_id, Types::String
      end
    end
  end
end
