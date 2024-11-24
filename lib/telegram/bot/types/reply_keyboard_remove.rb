# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ReplyKeyboardRemove < Base
        attribute :remove_keyboard, Types::True
        attribute? :selective, Types::Bool
      end
    end
  end
end
