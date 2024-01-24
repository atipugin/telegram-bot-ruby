# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ReactionType = ( # rubocop:disable Naming/ConstantName
        ReactionTypeEmoji |
        ReactionTypeCustomEmoji
      )
    end
  end
end
