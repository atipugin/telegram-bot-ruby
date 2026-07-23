# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextSubscript < Base
        attribute :type, Types::String.constrained(eql: 'subscript').default('subscript')
        attribute :text, Types.deferred(:RichText)
      end
    end
  end
end
