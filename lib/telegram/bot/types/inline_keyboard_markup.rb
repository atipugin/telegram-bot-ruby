# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineKeyboardMarkup < Base
        attribute :inline_keyboard, Types::Array.of(Types::Array.of(InlineKeyboardButton))

        def to_compact_hash
          hsh = super
          hsh[:inline_keyboard].map! do |arr|
            arr.map do |item|
              item.is_a?(InlineKeyboardButton) ? item.to_compact_hash : item
            end
          end

          hsh
        end
      end
    end
  end
end
