# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BackgroundTypePattern < Base
        attribute :type, Types::String.constrained(eql: 'pattern').default('pattern')
        attribute :document, Document
        attribute :fill, BackgroundFill
        attribute :intensity, Types::Integer
        attribute? :is_inverted, Types::True
        attribute? :is_moving, Types::True
      end
    end
  end
end
