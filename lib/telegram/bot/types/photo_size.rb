# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PhotoSize < Base
        attribute :file_id, Types::String
        attribute :file_unique_id, Types::String
        attribute :width, Types::Integer
        attribute :height, Types::Integer
        attribute? :file_size, Types::Integer
      end
    end
  end
end
