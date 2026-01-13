# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class AcceptedGiftTypes < Base
        attribute :unlimited_gifts, Types::Bool
        attribute :limited_gifts, Types::Bool
        attribute :unique_gifts, Types::Bool
        attribute :premium_subscription, Types::Bool
        attribute :gifts_from_channels, Types::Bool
      end
    end
  end
end
