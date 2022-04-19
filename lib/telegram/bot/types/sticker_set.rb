# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class StickerSet < Base
        attribute :name, String
        attribute :title, String
        attribute :is_animated, Boolean
        attribute :is_video, Boolean
        attribute :contains_masks, Boolean
        attribute :stickers, Array[Sticker]
        attribute :thumb, PhotoSize
      end
    end
  end
end
