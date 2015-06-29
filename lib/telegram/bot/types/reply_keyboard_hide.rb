module Telegram
  module Bot
    module Types
      class ReplyKeyboardHide < Base
        attribute :hide_keyboard, Boolean
        attribute :selective, Boolean, default: false
      end
    end
  end
end
