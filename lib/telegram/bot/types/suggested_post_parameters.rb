# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SuggestedPostParameters < Base
        attribute? :price, SuggestedPostPrice
        attribute? :send_date, Types::Integer
      end
    end
  end
end
