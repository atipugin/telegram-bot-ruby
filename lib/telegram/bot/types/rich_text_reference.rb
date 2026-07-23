# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextReference < Base
        attribute :type, Types::String.constrained(eql: 'reference').default('reference')
        attribute :text, Types.deferred(:RichText)
        attribute :name, Types::String
      end
    end
  end
end
