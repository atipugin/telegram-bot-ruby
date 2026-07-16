# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SuccessfulPayment < Base
        attribute :currency, Types::String
        attribute :total_amount, Types::Integer
        attribute :invoice_payload, Types::String
        attribute? :subscription_expiration_date, Types::Integer
        attribute? :is_recurring, Types::True
        attribute? :is_first_recurring, Types::True
        attribute? :shipping_option_id, Types::String
        attribute? :order_info, OrderInfo
        attribute :telegram_payment_charge_id, Types::String
        attribute :provider_payment_charge_id, Types::String
      end
    end
  end
end
