# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockDivider < Base
        attribute :type, Types::String.constrained(eql: 'divider').default('divider')
      end
    end
  end
end
