# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PassportElementErrorUnspecified < Base
        attribute :source, Types::String.default('unspecified')
        attribute :type, Types::String
        attribute :element_hash, Types::String
        attribute :message, Types::String
      end
    end
  end
end
