# frozen_string_literal: true

require_relative 'encrypted_passport_element'
require_relative 'encrypted_credentials'

module Telegram
  module Bot
    module Types
      class PassportData < Base
        attribute :data, Types::Array.of(EncryptedPassportElement)
        attribute :credentials, EncryptedCredentials
      end
    end
  end
end
