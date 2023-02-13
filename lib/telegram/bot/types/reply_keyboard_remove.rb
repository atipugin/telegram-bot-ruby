# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ReplyKeyboardRemove < Base
        attribute :remove_keyboard, Types::Bool
        attribute? :selective, Types::Bool.default(false)
      end
    end
  end
end
