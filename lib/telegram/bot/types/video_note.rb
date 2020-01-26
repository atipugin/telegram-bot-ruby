module Telegram
  module Bot
    module Types
      class VideoNote < Base
        attribute :file_id, String
        attribute :file_unique_id, String
        attribute :length, Integer
        attribute :duration, Integer
        attribute :thumb, PhotoSize
        attribute :file_size, Integer
      end
    end
  end
end
