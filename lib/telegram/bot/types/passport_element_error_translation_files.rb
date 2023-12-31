# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PassportElementErrorTranslationFiles < Base
        attribute :source, Types::String.constrained(eql: 'translation_files').default('translation_files')
        attribute :type, Types::String
        attribute :file_hashes, Types::Array.of(Types::String)
        attribute :message, Types::String
      end
    end
  end
end
