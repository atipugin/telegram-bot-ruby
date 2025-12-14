# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class GiftInfo < Base
        attribute :gift, Gift
        attribute? :owned_gift_id, Types::String
        attribute? :convert_star_count, Types::Integer
        attribute? :prepaid_upgrade_star_count, Types::Integer
        attribute? :can_be_upgraded, Types::True
        attribute? :text, Types::String
        attribute? :entities, Types::Array.of(MessageEntity)
        attribute? :is_private, Types::True
      end
    end
  end
end
