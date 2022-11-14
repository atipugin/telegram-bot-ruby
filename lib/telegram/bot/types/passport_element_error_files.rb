# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PassportElementErrorFiles < Base
        attribute :source, Types::String.default('files')
        attribute :type, Types::String
        attribute :file_hashes, Types::Array.of(String)
        attribute :message, Types::String
      end
    end
  end
end
