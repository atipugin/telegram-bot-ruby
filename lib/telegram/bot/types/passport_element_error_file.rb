module Telegram
  module Bot
    module Types
      class PassportElementErrorFile < Base
        attribute :source, String, default: 'file'
        attribute :type, String
        attribute :file_hash, String
        attribute :message, String
      end
    end
  end
end
