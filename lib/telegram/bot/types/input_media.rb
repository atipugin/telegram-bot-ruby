# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ## Just for classes consistency
      # rubocop:disable Naming/ConstantName
      InputMedia = (
        InputMediaAnimation |
        InputMediaDocument |
        InputMediaAudio |
        InputMediaPhoto |
        InputMediaVideo
      )
      # rubocop:enable Naming/ConstantName
    end
  end
end
