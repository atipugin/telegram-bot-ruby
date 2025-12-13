# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SuggestedPostInfo < Base
        attribute :state, Types::String
        attribute? :price, SuggestedPostPrice
        attribute? :send_date, Types::Integer
      end
    end
  end
end
