# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextReferenceLink < Base
        attribute :type, Types::String.constrained(eql: 'reference_link').default('reference_link')
        attribute :text, Types.deferred(:RichText)
        attribute :reference_name, Types::String
      end
    end
  end
end
