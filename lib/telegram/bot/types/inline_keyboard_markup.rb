module Telegram
  module Bot
    module Types
      class InlineKeyboardMarkup < Base
        attribute :inline_keyboard, Array[Array[InlineKeyboardButton]]

        def to_h
          hsh = super
          hsh[:inline_keyboard].map! { |a| a.map(&:to_h) }

          hsh
        end
      end
    end
  end
end
