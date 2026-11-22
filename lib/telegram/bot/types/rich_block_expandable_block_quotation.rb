# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockExpandableBlockQuotation < Base
        attribute :type, Types::String.constrained(eql: 'expandable_blockquote').default('expandable_blockquote')
        attribute :blocks, Types::Array.of(Types.deferred(:RichBlock))
        attribute? :credit, RichText
      end
    end
  end
end
