# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UniqueGiftBackdropColors < Base
        attribute :center_color, Types::Integer
        attribute :edge_color, Types::Integer
        attribute :symbol_color, Types::Integer
        attribute :text_color, Types::Integer
      end
    end
  end
end
