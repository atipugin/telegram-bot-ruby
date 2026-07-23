# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockList < Base
        attribute :type, Types::String.constrained(eql: 'list').default('list')
        attribute :items, Types::Array.of(RichBlockListItem)
      end
    end
  end
end
