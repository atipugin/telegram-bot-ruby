# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      MessageOrigin = ( # rubocop:disable Naming/ConstantName
        MessageOriginUser |
        MessageOriginHiddenUser |
        MessageOriginChat |
        MessageOriginChannel
      )
    end
  end
end
