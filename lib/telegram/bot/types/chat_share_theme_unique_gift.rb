# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatShareThemeUniqueGift < Base
        attribute :type, Types::String.constrained(eql: 'unique_gift').default('unique_gift')
        attribute :gift, UniqueGift
      end
    end
  end
end
