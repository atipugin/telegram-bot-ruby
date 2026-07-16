# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ReplyKeyboardMarkup < Base
        attribute :keyboard, Types::Array.of(Types::Array.of(KeyboardButton))
        attribute? :is_persistent, Types::Bool.default(false)
        attribute? :resize_keyboard, Types::Bool.default(false)
        attribute? :one_time_keyboard, Types::Bool.default(false)
        attribute? :input_field_placeholder, Types::String.constrained(min_size: 1, max_size: 64)
        attribute? :selective, Types::Bool

        def to_compact_hash
          hsh = super
          hsh[:keyboard].map! do |arr|
            arr.map do |item|
              item.is_a?(KeyboardButton) ? item.to_compact_hash : item
            end
          end

          hsh
        end
      end
    end
  end
end
