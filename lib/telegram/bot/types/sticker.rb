module Telegram
  module Bot
    module Types
      class Sticker < Base
        attribute :file_id, String
        attribute :width, Integer
        attribute :height, Integer
        attribute :thumb, PhotoSize
        attribute :file_size, Integer
      end
    end
  end
end
