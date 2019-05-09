module Telegram
  module Bot
    module Types
      class EncryptedCredentials < Base
        attribute :data, String
        attribute :hash, String
        attribute :secret, String
      end
    end
  end
end
