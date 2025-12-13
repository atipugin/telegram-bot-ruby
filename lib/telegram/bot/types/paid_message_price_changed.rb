# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PaidMessagePriceChanged < Base
        attribute :paid_message_star_count, Types::Integer
      end
    end
  end
end
