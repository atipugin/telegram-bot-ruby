# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class OrderInfo < Base
        attribute? :name, Types::String
        attribute? :phone_number, Types::String
        attribute? :email, Types::String
        attribute? :shipping_address, ShippingAddress
      end
    end
  end
end
