# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      MaybeInaccessibleMessage = ( # rubocop:disable Naming/ConstantName
        Message |
        InaccessibleMessage
      )
    end
  end
end
