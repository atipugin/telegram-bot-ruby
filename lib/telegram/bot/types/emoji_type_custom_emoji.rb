# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class EmojiTypeCustomEmoji < Base
        attribute :type, Types::String.constrained(eql: 'custom_emoji').default('custom_emoji')
        attribute :custom_emoji_id, Types::String
      end
    end
  end
end
