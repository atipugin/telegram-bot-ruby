module Telegram
  module Bot
    module Types
      class OrderInfo < Base
        attribute :name, String
        attribute :phone_number, String
        attribute :email, String
        attribute :shipping_address, ShippingAddress
      end
    end
  end
end
