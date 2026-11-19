# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TonNft < Base
        attribute :address, Types::String
        attribute? :collection_address, Types::String
        attribute :index, Types::String
        attribute :name, Types::String
        attribute :description, Types::String
        attribute? :attributes, Types::Array.of(TonNftAttribute)
        attribute? :gift, UniqueGift
      end
    end
  end
end
