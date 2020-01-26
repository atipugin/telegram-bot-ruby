module Telegram
  module Bot
    module Types
      class Voice < Base
        attribute :file_id, String
        attribute :file_unique_id, String
        attribute :duration, Integer
        attribute :mime_type, String
        attribute :file_size, Integer
      end
    end
  end
end
