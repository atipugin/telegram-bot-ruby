# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class LivePhoto < Base
        attribute? :photo, Types::Array.of(PhotoSize)
        attribute :file_id, Types::String
        attribute :file_unique_id, Types::String
        attribute :width, Types::Integer
        attribute :height, Types::Integer
        attribute :duration, Types::Integer
        attribute? :mime_type, Types::String
        attribute? :file_size, Types::Integer
      end
    end
  end
end
