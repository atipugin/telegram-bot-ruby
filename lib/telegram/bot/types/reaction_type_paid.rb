# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ReactionTypePaid < Base
        attribute :type, Types::String.constrained(eql: 'paid').default('paid')
      end
    end
  end
end
