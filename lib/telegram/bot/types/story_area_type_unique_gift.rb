# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class StoryAreaTypeUniqueGift < Base
        attribute :type, Types::String.constrained(eql: 'unique_gift').default('unique_gift')
        attribute :name, Types::String
      end
    end
  end
end
