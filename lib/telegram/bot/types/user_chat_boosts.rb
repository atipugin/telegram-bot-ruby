# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UserChatBoosts < Base
        attribute :boosts, Types::Array.of(ChatBoost)
      end
    end
  end
end
