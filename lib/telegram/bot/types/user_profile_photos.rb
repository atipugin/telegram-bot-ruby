# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UserProfilePhotos < Base
        attribute :total_count, Types::Integer
        attribute :photos, Types::Array.of(Types::Array.of(PhotoSize))
      end
    end
  end
end
