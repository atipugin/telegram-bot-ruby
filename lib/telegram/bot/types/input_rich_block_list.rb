# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockList < Base
        attribute :type, Types::String.constrained(eql: 'list').default('list')
        attribute :items, Types::Array.of(InputRichBlockListItem)
      end
    end
  end
end
