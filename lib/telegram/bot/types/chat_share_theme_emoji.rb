# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatShareThemeEmoji < Base
        attribute :type, Types::String.constrained(eql: 'emoji').default('emoji')
        attribute :emojis, Types::Array.of(EmojiType).constrained(min_size: 0, max_size: 6)
        attribute? :background_backdrop_id, Types::Integer
      end
    end
  end
end
