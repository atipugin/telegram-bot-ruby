# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UniqueGift < Base
        attribute :base_name, Types::String
        attribute :name, Types::String
        attribute :number, Types::Integer
        attribute :model, UniqueGiftModel
        attribute :symbol, UniqueGiftSymbol
        attribute :backdrop, UniqueGiftBackdrop
        attribute? :publisher_chat, Chat
      end
    end
  end
end
