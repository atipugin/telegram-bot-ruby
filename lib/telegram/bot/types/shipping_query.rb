module Telegram
  module Bot
    module Types
      class ShippingQuery < Base
        attribute :id, String
        attribute :from, User
        attribute :invoice_payload, String
        attribute :shipping_address, ShippingAddress
      end
    end
  end
end
