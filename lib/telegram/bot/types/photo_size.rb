module Telegram
  module Bot
    module Types
      class PhotoSize < Base
        attribute :file_id, String
        attribute :file_unique_id, String
        attribute :width, Integer
        attribute :height, Integer
        attribute :file_size, Integer
      end
    end
  end
end
