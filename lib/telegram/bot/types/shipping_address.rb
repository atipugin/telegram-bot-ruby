# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ShippingAddress < Base
        attribute :country_code, Types::String
        attribute :state, Types::String
        attribute :city, Types::String
        attribute :street_line1, Types::String
        attribute :street_line2, Types::String
        attribute :post_code, Types::String
      end
    end
  end
end
