# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SuggestedPostPrice < Base
        attribute :currency, Types::String
        attribute :amount, Types::Integer.constrained(min_size: 5, max_size: 100000)
      end
    end
  end
end
