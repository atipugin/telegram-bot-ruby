# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class DirectMessagePriceChanged < Base
        attribute :are_direct_messages_enabled, Types::Bool
        attribute? :direct_message_star_count, Types::Integer.default(0)
      end
    end
  end
end
