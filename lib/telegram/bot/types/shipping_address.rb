module Telegram
  module Bot
    module Types
      class ShippingAddress < Base
        attribute :country_code, String
        attribute :state, String
        attribute :city, String
        attribute :street_line1, String
        attribute :street_line2, String
        attribute :post_code, String
      end
    end
  end
end
