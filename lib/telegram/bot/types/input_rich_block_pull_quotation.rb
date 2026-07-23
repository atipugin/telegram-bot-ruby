# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockPullQuotation < Base
        attribute :type, Types::String.constrained(eql: 'pullquote').default('pullquote')
        attribute :text, RichText
        attribute? :credit, RichText
      end
    end
  end
end
