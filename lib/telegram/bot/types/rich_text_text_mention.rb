# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextTextMention < Base
        attribute :type, Types::String.constrained(eql: 'text_mention').default('text_mention')
        attribute :text, Types.deferred(:RichText)
        attribute :user, User
      end
    end
  end
end
