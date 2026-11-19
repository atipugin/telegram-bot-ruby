# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatShareThemeBackdrops < Base
        attribute :backdrops, Types::Array.of(ChatShareThemeBackdrop)
      end
    end
  end
end
