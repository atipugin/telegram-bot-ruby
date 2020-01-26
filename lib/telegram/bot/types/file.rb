module Telegram
  module Bot
    module Types
      class File < Base
        attribute :file_id, String
        attribute :file_unique_id, String
        attribute :file_size, Integer
        attribute :file_path, String
      end
    end
  end
end
