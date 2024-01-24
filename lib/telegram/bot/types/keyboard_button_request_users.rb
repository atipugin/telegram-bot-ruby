# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class KeyboardButtonRequestUsers < Base
        attribute :request_id, Types::Integer
        attribute? :user_is_bot, Types::Bool
        attribute? :user_is_premium, Types::Bool
        attribute? :max_quantity, Types::Integer.default(1)
      end
    end
  end
end
