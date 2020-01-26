module Telegram
  module Bot
    module Types
      class ChatPhoto < Base
        attribute :small_file_id, String
        attribute :small_file_unique_id, String
        attribute :big_file_id, String
        attribute :big_file_unique_id, String
      end
    end
  end
end
