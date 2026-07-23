# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextMention < Base
        attribute :type, Types::String.constrained(eql: 'mention').default('mention')
        attribute :text, Types.deferred(:RichText)
        attribute :username, Types::String
      end
    end
  end
end
