# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class LabeledPrice < Base
        attribute :label, Types::String
        attribute :amount, Types::Integer
      end
    end
  end
end
