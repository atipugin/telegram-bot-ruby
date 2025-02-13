# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Video < Base
        attribute :file_id, Types::String
        attribute :file_unique_id, Types::String
        attribute :width, Types::Integer
        attribute :height, Types::Integer
        attribute :duration, Types::Integer
        attribute? :thumbnail, PhotoSize
        attribute? :cover, Types::Array.of(PhotoSize)
        attribute? :start_timestamp, Types::Integer
        attribute? :file_name, Types::String
        attribute? :mime_type, Types::String
        attribute? :file_size, Types::Integer
      end
    end
  end
end
