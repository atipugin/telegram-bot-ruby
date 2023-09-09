# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PassportElementErrorSelfie < Base
        attribute :source, Types::String.constrained(eql: 'selfie').default('selfie')
        attribute :type, Types::String
        attribute :file_hash, Types::String
        attribute :message, Types::String
      end
    end
  end
end
