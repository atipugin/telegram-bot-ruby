# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ReactionTypeEmoji < Base
        attribute :type, Types::String.constrained(eql: 'emoji').default('emoji')
        attribute :emoji, Types::String
      end
    end
  end
end
