# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UniqueGiftBackdrop < Base
        attribute :name, Types::String
        attribute :colors, UniqueGiftBackdropColors
        attribute :rarity_per_mille, Types::Integer
      end
    end
  end
end
