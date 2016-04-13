module Telegram
  module Bot
    module Types
      class InlineKeyboardMarkup < Base
        attribute :inline_keyboard, Array[Array[InlineKeyboardButton]]

        def to_h
          hsh = super
          hsh[:inline_keyboard].map! do |arr|
            arr.map { |i| i.is_a?(InlineKeyboardButton) ? i.to_h : i }
          end

          hsh
        end
      end
    end
  end
end
