# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockDetails < Base
        attribute :type, Types::String.constrained(eql: 'details').default('details')
        attribute :summary, RichText
        attribute :blocks, Types::Array.of(Types.deferred(:InputRichBlock))
        attribute? :is_open, Types::True
      end
    end
  end
end
