# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ## Just for classes consistency
      # rubocop:disable Naming/ConstantName
      InputMessageContent = (
        InputTextMessageContent |
        InputLocationMessageContent |
        InputVenueMessageContent |
        InputContactMessageContent |
        InputInvoiceMessageContent
      )
      # rubocop:enable Naming/ConstantName
    end
  end
end
