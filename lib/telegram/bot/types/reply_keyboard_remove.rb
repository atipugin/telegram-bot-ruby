module Telegram
  module Bot
    module Types
      class ReplyKeyboardRemove < Base
        attribute :remove_keyboard, Boolean
        attribute :selective, Boolean, default: false
      end
    end
  end
end
