module Telegram
  module Bot
    module Types
      class PassportElementErrorTranslationFiles < Base
        attribute :source, String, default: 'translation_files'
        attribute :type, String
        attribute :file_hashes, Array[String]
        attribute :message, String
      end
    end
  end
end
