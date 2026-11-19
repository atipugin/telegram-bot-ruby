# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TonWalletCard < Base
        attribute :address, Types::String
        attribute :amount, Types::String
        attribute :stickers, Types::Array.of(TonWalletCardSticker)
        attribute? :background_nft_address, Types::String
      end
    end
  end
end
