# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UserRating < Base
        attribute :level, Types::Integer
        attribute :rating, Types::Integer
        attribute :current_level_rating, Types::Integer
        attribute? :next_level_rating, Types::Integer
      end
    end
  end
end
