# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Voice < Base
        attribute :file_id, Types::String
        attribute :file_unique_id, Types::String
        attribute :duration, Types::Integer
        attribute? :mime_type, Types::String
        attribute? :file_size, Types::Integer
      end
    end
  end
end
