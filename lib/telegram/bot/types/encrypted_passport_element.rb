# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class EncryptedPassportElement < Base
        attribute :type, Types::String
        attribute? :data, Types::String
        attribute? :phone_number, Types::String
        attribute? :email, Types::String
        attribute? :files, Types::Array.of(PassportFile)
        attribute? :front_side, PassportFile
        attribute? :reverse_side, PassportFile
        attribute? :selfie, PassportFile
        attribute? :translation, Types::Array.of(PassportFile)
        attribute :hash, Types::String
      end
    end
  end
end
