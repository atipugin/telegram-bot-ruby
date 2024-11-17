# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BackgroundFillGradient < Base
        attribute :type, Types::String.constrained(eql: 'gradient').default('gradient')
        attribute :top_color, Types::Integer
        attribute :bottom_color, Types::Integer
        attribute :rotation_angle, Types::Integer
      end
    end
  end
end
