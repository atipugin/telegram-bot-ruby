module Telegram
  module Bot
    module Types
      class PassportElementErrorTranslationFile < Base
        attribute :source, String, default: 'translation_file'
        attribute :type, String
        attribute :file_hash, String
        attribute :message, String
      end
    end
  end
end
