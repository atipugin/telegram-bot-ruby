# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UniqueGiftColors < Base
        attribute :model_custom_emoji_id, Types::String
        attribute :symbol_custom_emoji_id, Types::String
        attribute :light_theme_main_color, Types::Integer
        attribute :light_theme_other_colors, Types::Array.of(Types::Integer)
        attribute :dark_theme_main_color, Types::Integer
        attribute :dark_theme_other_colors, Types::Array.of(Types::Integer)
      end
    end
  end
end
