module Telegram
  module Bot
    module Types
      class ReplyKeyboardMarkup < Base
        attribute :keyboard, Array[Array[KeyboardButton]]
        attribute :resize_keyboard, Boolean, default: false
        attribute :one_time_keyboard, Boolean, default: false
        attribute :selective, Boolean, default: false

        def to_h
          hsh = super
          hsh[:keyboard].map! do |arr|
            arr.map { |i| i.is_a?(KeyboardButton) ? i.to_h : i }
          end

          hsh
        end
      end
    end
  end
end
