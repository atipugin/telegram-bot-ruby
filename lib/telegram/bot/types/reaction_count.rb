# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ReactionCount < Base
        attribute :type, ReactionType
        attribute :total_count, Types::Integer
      end
    end
  end
end
