module Telegram
  module Bot
    module Types
      class InlineKeyboardMarkup < Base
        attribute :inline_keyboard, Array[Array[InlineKeyboardButton]]
      end
    end
  end
end
