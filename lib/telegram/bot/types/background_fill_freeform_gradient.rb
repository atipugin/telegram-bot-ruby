# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BackgroundFillFreeformGradient < Base
        attribute :type, Types::String.constrained(eql: 'freeform_gradient').default('freeform_gradient')
        attribute :colors, Types::Array.of(Types::Integer)
      end
    end
  end
end
