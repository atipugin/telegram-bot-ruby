# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockDetails < Base
        attribute :type, Types::String.constrained(eql: 'details').default('details')
        attribute :summary, RichText
        attribute :blocks, Types::Array.of(Types.deferred(:RichBlock))
        attribute? :is_open, Types::True
      end
    end
  end
end
