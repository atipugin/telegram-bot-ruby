# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class OwnedGiftUnique < Base
        attribute :type, Types::String.constrained(eql: 'unique').default('unique')
        attribute :gift, UniqueGift
        attribute? :owned_gift_id, Types::String
        attribute? :sender_user, User
        attribute :send_date, Types::Integer
        attribute? :is_saved, Types::True
        attribute? :can_be_transferred, Types::True
        attribute? :transfer_star_count, Types::Integer
        attribute? :next_transfer_date, Types::Integer
      end
    end
  end
end
