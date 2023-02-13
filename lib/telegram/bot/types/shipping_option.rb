# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ShippingOption < Base
        attribute :id, Types::String
        attribute :title, Types::String
        attribute :prices, Types::Array.of(LabeledPrice)
      end
    end
  end
end
