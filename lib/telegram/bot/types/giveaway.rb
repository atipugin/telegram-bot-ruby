# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Giveaway < Base
        attribute :chats, Types::Array.of(Chat)
        attribute :winners_selection_date, Types::Integer
        attribute :winner_count, Types::Integer
        attribute? :only_new_members, Types::True
        attribute? :has_public_winners, Types::True
        attribute? :prize_description, Types::String
        attribute? :country_codes, Types::Array.of(Types::String)
        attribute? :prize_star_count, Types::Integer
        attribute? :premium_subscription_month_count, Types::Integer
      end
    end
  end
end
