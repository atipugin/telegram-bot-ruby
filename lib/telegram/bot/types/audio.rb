# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Audio < Base
        attribute :file_id, Types::String
        attribute :file_unique_id, Types::String
        attribute :duration, Types::Integer
        attribute? :performer, Types::String
        attribute? :title, Types::String
        attribute? :file_name, Types::String
        attribute? :mime_type, Types::String
        attribute? :file_size, Types::Integer
        attribute? :thumbnail, PhotoSize
      end
    end
  end
end
