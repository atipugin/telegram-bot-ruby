# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatShareThemeBackdrop < Base
        attribute :id, Types::Integer
        attribute :name, Types::String
        attribute :colors, UniqueGiftBackdropColors
      end
    end
  end
end
