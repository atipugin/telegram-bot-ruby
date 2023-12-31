# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PassportElementErrorFiles < Base
        attribute :source, Types::String.constrained(eql: 'files').default('files')
        attribute :type, Types::String
        attribute :file_hashes, Types::Array.of(Types::String)
        attribute :message, Types::String
      end
    end
  end
end
