# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockBlockQuotation < Base
        attribute :type, Types::String.constrained(eql: 'blockquote').default('blockquote')
        attribute :blocks, Types::Array.of(Types.deferred(:RichBlock))
        attribute? :credit, RichText
      end
    end
  end
end
