module Telegram
  module Bot
    module Types
      class Audio < Base
        attribute :file_id, String
        attribute :duration, Integer
        attribute :mime_type, String
        attribute :file_size, Integer
      end
    end
  end
end
