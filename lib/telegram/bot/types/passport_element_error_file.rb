# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PassportElementErrorFile < Base
        attribute :source, Types::String.constrained(eql: 'file').default('file')
        attribute :type, Types::String
        attribute :file_hash, Types::String
        attribute :message, Types::String
      end
    end
  end
end
