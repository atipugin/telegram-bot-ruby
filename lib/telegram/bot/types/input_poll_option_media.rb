# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ## Just for classes consistency
      # rubocop:disable Naming/ConstantName
      InputPollOptionMedia = (
        InputMediaAnimation |
        InputMediaLivePhoto |
        InputMediaLocation |
        InputMediaPhoto |
        InputMediaSticker |
        InputMediaVenue |
        InputMediaVideo
      )
      # rubocop:enable Naming/ConstantName
    end
  end
end
