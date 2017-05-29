module Telegram
  module Bot
    module Types
      class ShippingOption < Base
        attribute :id, String
        attribute :title, String
        attribute :prices, Array[LabeledPrice]
      end
    end
  end
end
