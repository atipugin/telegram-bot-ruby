# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class GiveawayWinners < Base
        attribute :chat, Chat
        attribute :giveaway_message_id, Types::Integer
        attribute :winners_selection_date, Types::Integer
        attribute :winner_count, Types::Integer
        attribute :winners, Types::Array.of(User)
        attribute? :additional_chat_count, Types::Integer
        attribute? :prize_star_count, Types::Integer
        attribute? :premium_subscription_month_count, Types::Integer
        attribute? :unclaimed_prize_count, Types::Integer
        attribute? :only_new_members, Types::True
        attribute? :was_refunded, Types::True
        attribute? :prize_description, Types::String
      end
    end
  end
end
