module Telegram
  module Bot
    module Types
      class StickerSet < Base
        attribute :name, String
        attribute :title, String
        attribute :contains_masks, Boolean
        attribute :stickers, Array[Sticker]
      end
    end
  end
end
