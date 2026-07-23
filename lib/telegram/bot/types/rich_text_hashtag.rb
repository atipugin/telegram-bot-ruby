# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextHashtag < Base
        attribute :type, Types::String.constrained(eql: 'hashtag').default('hashtag')
        attribute :text, Types.deferred(:RichText)
        attribute :hashtag, Types::String
      end
    end
  end
end
