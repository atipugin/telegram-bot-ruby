# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TonWalletCardSticker < Base
        attribute :position, AreaPosition
        attribute :nft, TonNft
      end
    end
  end
end
