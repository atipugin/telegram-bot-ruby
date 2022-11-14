# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SuccessfulPayment < Base
        attribute :currency, Types::String
        attribute :total_amount, Types::Integer
        attribute :invoice_payload, Types::String
        attribute? :shipping_option_id, Types::String
        attribute? :order_info, OrderInfo
        attribute :telegram_payment_charge_id, Types::String
        attribute :provider_payment_charge_id, Types::String
      end
    end
  end
end
