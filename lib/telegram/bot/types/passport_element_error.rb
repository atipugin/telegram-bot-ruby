# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ## Just for classes consistency
      # rubocop:disable Naming/ConstantName
      PassportElementError = (
        PassportElementErrorDataField |
        PassportElementErrorFrontSide |
        PassportElementErrorReverseSide |
        PassportElementErrorSelfie |
        PassportElementErrorFile |
        PassportElementErrorFiles |
        PassportElementErrorTranslationFile |
        PassportElementErrorTranslationFiles |
        PassportElementErrorUnspecified
      )
      # rubocop:enable Naming/ConstantName
    end
  end
end
