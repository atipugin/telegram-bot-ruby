# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextMarked < Base
        attribute :type, Types::String.constrained(eql: 'marked').default('marked')
        attribute :text, Types.deferred(:RichText)
      end
    end
  end
end
