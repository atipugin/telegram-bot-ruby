# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class GiveawayCreated < Base
        attribute? :prize_star_count, Types::Integer
      end
    end
  end
end
