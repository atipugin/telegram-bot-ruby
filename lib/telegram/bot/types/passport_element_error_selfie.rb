module Telegram
  module Bot
    module Types
      class PassportElementErrorSelfie < Base
        attribute :source, String, default: 'selfie'
        attribute :type, String
        attribute :file_hash, String
        attribute :message, String
      end
    end
  end
end
