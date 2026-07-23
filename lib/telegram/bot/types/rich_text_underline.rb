# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextUnderline < Base
        attribute :type, Types::String.constrained(eql: 'underline').default('underline')
        attribute :text, Types.deferred(:RichText)
      end
    end
  end
end
