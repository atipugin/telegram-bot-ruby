# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UniqueGift < Base
        attribute :gift_id, Types::String
        attribute :base_name, Types::String
        attribute :name, Types::String
        attribute :number, Types::Integer
        attribute :model, UniqueGiftModel
        attribute :symbol, UniqueGiftSymbol
        attribute :backdrop, UniqueGiftBackdrop
        attribute? :is_premium, Types::True
        attribute? :is_from_blockchain, Types::True
        attribute? :colors, UniqueGiftColors
        attribute? :publisher_chat, Chat
      end
    end
  end
end
