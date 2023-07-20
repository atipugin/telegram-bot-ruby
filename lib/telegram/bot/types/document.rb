# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Document < Base
        attribute :file_id, Types::String
        attribute :file_unique_id, Types::String
        attribute? :thumbnail, PhotoSize
        attribute? :file_name, Types::String
        attribute? :mime_type, Types::String
        attribute? :file_size, Types::Integer
      end
    end
  end
end
