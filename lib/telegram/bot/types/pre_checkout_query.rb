module Telegram
  module Bot
    module Types
      class PreCheckoutQuery < Base
        attribute :id, String
        attribute :from, User
        attribute :currency, String
        attribute :total_amount, Integer
        attribute :invoice_payload, String
        attribute :shipping_option_id, String
        attribute :order_info, OrderInfo
      end
    end
  end
end
