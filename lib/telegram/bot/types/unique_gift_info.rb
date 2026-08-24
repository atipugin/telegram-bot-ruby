# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UniqueGiftInfo < Base
        attribute :gift, UniqueGift
        attribute :origin, Types::String
        attribute? :text, Types::String
        attribute? :entities, Types::Array.of(MessageEntity)
        attribute? :is_private, Types::True
        attribute? :last_resale_currency, Types::String
        attribute? :last_resale_amount, Types::Integer
        attribute? :owned_gift_id, Types::String
        attribute? :transfer_star_count, Types::Integer
        attribute? :next_transfer_date, Types::Integer
      end
    end
  end
end
