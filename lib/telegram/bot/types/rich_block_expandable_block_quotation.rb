# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockExpandableBlockQuotation < Base
        attribute :type, Types::String.constrained(eql: 'expandable_blockquote').default('expandable_blockquote')
        attribute :text, RichText
        attribute? :credit, RichText
      end
    end
  end
end
