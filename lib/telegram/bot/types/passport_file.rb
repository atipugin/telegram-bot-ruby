module Telegram
  module Bot
    module Types
      class PassportFile < Base
        attribute :file_id, String
        attribute :file_unique_id, String
        attribute :file_size, Integer
        attribute :file_date, Integer
      end
    end
  end
end
