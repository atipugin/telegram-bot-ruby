# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextItalic < Base
        attribute :type, Types::String.constrained(eql: 'italic').default('italic')
        attribute :text, Types.deferred(:RichText)
      end
    end
  end
end
