module Telegram
  module Bot
    module Types
      class PassportElementErrorReverseSide < Base
        attribute :source, String, default: 'reverse_side'
        attribute :type, String
        attribute :file_hash, String
        attribute :message, String
      end
    end
  end
end
