module Telegram
  module Bot
    module Types
      class PassportData < Base
        attribute :data, Array[EncryptedPassportElement]
        attribute :credentials, EncryptedCredentials
      end
    end
  end
end
