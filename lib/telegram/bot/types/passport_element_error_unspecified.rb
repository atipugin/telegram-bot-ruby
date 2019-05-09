module Telegram
  module Bot
    module Types
      class PassportElementErrorUnspecified < Base
        attribute :source, String, default: 'unspecified'
        attribute :type, String
        attribute :element_hash, String
        attribute :message, String
      end
    end
  end
end
