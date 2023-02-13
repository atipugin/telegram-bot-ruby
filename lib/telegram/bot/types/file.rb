# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class File < Base
        attribute :file_id, Types::String
        attribute :file_unique_id, Types::String
        attribute? :file_size, Types::Integer
        attribute? :file_path, Types::String
      end
    end
  end
end
