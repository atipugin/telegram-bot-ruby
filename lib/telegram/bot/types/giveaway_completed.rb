# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class GiveawayCompleted < Base
        attribute :winner_count, Types::Integer
        attribute? :unclaimed_prize_count, Types::Integer
        attribute? :giveaway_message, Message
        attribute? :is_star_giveaway, Types::True
      end
    end
  end
end
