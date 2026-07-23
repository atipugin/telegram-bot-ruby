# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextStrikethrough < Base
        attribute :type, Types::String.constrained(eql: 'strikethrough').default('strikethrough')
        attribute :text, Types.deferred(:RichText)
      end
    end
  end
end
