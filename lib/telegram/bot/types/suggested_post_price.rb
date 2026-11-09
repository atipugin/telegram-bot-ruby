# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SuggestedPostPrice < Base
        attribute :currency, Types::String
        attribute :amount, Types::Integer.constrained(gteq: 5, lteq: 100_000) |
                           Types::Integer.constrained(gteq: 10_000_000, lteq: 10_000_000_000_000)
      end
    end
  end
end
