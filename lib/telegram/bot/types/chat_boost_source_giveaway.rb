# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatBoostSourceGiveaway < Base
        attribute :source, Types::String.constrained(eql: 'giveaway').default('giveaway')
        attribute :giveaway_message_id, Types::Integer
        attribute? :user, User
        attribute? :prize_star_count, Types::Integer
        attribute? :is_unclaimed, Types::True
      end
    end
  end
end
