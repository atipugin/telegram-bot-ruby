# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class OwnedGifts < Base
        attribute :total_count, Types::Integer
        attribute :gifts, Types::Array.of(OwnedGift)
        attribute? :next_offset, Types::String
      end
    end
  end
end
