module Telegram
  module Bot
    module Types
      class PassportElementErrorFrontSide < Base
        attribute :source, String, default: 'front_side'
        attribute :type, String
        attribute :file_hash, String
        attribute :message, String
      end
    end
  end
end
