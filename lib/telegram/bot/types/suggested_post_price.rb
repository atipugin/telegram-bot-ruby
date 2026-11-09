# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SuggestedPostPrice < Base
        attribute :currency, Types::String
        attribute :amount, Types::Integer
      end
    end
  end
end
