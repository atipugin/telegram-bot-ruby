# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatShareThemeEmoji < Base
        attribute :type, Types::String.constrained(eql: 'emoji').default('emoji')
        attribute :emojis, Types::Array.of(EmojiType)
        attribute? :background_backdrop_id, Types::Integer
      end
    end
  end
end
