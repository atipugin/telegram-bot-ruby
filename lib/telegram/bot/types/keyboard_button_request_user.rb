# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class KeyboardButtonRequestUser < Base
        attribute :request_id, Types::Integer
        attribute? :user_is_bot, Types::Bool
        attribute? :user_is_premium, Types::Bool
      end
    end
  end
end
