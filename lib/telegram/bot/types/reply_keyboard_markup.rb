# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ReplyKeyboardMarkup < Base
        attribute :keyboard, Array[Array[KeyboardButton]]
        attribute :resize_keyboard, Boolean, default: false
        attribute :one_time_keyboard, Boolean, default: false
        attribute :input_field_placeholder, String
        attribute :selective, Boolean, default: false

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
