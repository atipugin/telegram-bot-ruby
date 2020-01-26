module Telegram
  module Bot
    module Types
      class Sticker < Base
        attribute :file_id, String
        attribute :file_unique_id, String
        attribute :width, Integer
        attribute :height, Integer
        attribute :is_animated, Boolean
        attribute :thumb, PhotoSize
        attribute :emoji, String
        attribute :set_name, String
        attribute :mask_position, MaskPosition
        attribute :file_size, Integer
      end
    end
  end
end
