module Telegram
  module Bot
    module Types
      class PassportElementErrorFiles < Base
        attribute :source, String, default: 'files'
        attribute :type, String
        attribute :file_hashes, Array[String]
        attribute :message, String
      end
    end
  end
end
