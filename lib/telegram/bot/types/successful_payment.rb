module Telegram
  module Bot
    module Types
      class SuccessfulPayment < Base
        attribute :currency, String
        attribute :total_amount, Integer
        attribute :invoice_payload, String
        attribute :shipping_option_id, String
        attribute :order_info, OrderInfo
        attribute :telegram_payment_charge_id, String
        attribute :provider_payment_charge_id, String
      end
    end
  end
end
