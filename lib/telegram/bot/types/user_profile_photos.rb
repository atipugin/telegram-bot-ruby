module Telegram
  module Bot
    module Types
      class UserProfilePhotos < Base
        attribute :total_count, Integer
        attribute :photos, Array[Array[PhotoSize]]
      end
    end
  end
end
