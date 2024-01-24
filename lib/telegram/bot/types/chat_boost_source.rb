# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ChatBoostSource = ( # rubocop:disable Naming/ConstantName
        ChatBoostSourcePremium |
        ChatBoostSourceGiftCode |
        ChatBoostSourceGiveaway
      )
    end
  end
end
