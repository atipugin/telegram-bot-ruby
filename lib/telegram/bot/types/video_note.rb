# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class VideoNote < Base
        attribute :file_id, Types::String
        attribute :file_unique_id, Types::String
        attribute :length, Types::Integer
        attribute :duration, Types::Integer
        attribute? :thumbnail, PhotoSize
        attribute? :file_size, Types::Integer
      end
    end
  end
end
