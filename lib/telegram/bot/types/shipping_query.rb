# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ShippingQuery < Base
        attribute :id, Types::String
        attribute :from, User
        attribute :invoice_payload, Types::String
        attribute :shipping_address, ShippingAddress
      end
    end
  end
end
