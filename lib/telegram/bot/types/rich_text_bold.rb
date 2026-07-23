# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextBold < Base
        attribute :type, Types::String.constrained(eql: 'bold').default('bold')
        attribute :text, Types.deferred(:RichText)
      end
    end
  end
end
