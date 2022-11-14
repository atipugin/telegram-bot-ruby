# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PreCheckoutQuery < Base
        attribute :id, Types::String
        attribute :from, User
        attribute :currency, Types::String
        attribute :total_amount, Types::Integer
        attribute :invoice_payload, Types::String
        attribute? :shipping_option_id, Types::String
        attribute? :order_info, OrderInfo
      end
    end
  end
end
