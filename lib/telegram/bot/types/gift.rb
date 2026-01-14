# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Gift < Base
        attribute :id, Types::String
        attribute :sticker, Sticker
        attribute :star_count, Types::Integer
        attribute? :upgrade_star_count, Types::Integer
        attribute? :is_premium, Types::True
        attribute? :has_colors, Types::True
        attribute? :total_count, Types::Integer
        attribute? :remaining_count, Types::Integer
        attribute? :personal_total_count, Types::Integer
        attribute? :personal_remaining_count, Types::Integer
        attribute? :background, GiftBackground
        attribute? :unique_gift_variant_count, Types::Integer
        attribute? :publisher_chat, Chat
      end
    end
  end
end
