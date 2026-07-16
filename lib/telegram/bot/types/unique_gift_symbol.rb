# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UniqueGiftSymbol < Base
        attribute :name, Types::String
        attribute :sticker, Sticker
        attribute :rarity_per_mille, Types::Integer
      end
    end
  end
end
