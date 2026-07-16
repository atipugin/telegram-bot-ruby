# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class OwnedGiftRegular < Base
        attribute :type, Types::String.constrained(eql: 'regular').default('regular')
        attribute :gift, Gift
        attribute? :owned_gift_id, Types::String
        attribute? :sender_user, User
        attribute :send_date, Types::Integer
        attribute? :text, Types::String
        attribute? :entities, Types::Array.of(MessageEntity)
        attribute? :is_private, Types::True
        attribute? :is_saved, Types::True
        attribute? :can_be_upgraded, Types::True
        attribute? :was_refunded, Types::True
        attribute? :convert_star_count, Types::Integer
        attribute? :prepaid_upgrade_star_count, Types::Integer
        attribute? :is_upgrade_separate, Types::True
        attribute? :unique_gift_number, Types::Integer
      end
    end
  end
end
