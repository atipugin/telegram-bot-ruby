module Telegram
  module Bot
    module Types
      class StickerSet < Base
        attribute :name, String
        attribute :title, String
        attribute :is_animated, Boolean
        attribute :contains_masks, Boolean
        attribute :stickers, Array[Sticker]
        attribute :thumb, PhotoSize
      end
    end
  end
end
