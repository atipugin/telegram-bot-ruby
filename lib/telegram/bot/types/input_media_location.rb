# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputMediaLocation < Base
        attribute :type, Types::String.constrained(eql: 'location').default('location')
        attribute :latitude, Types::Float
        attribute :longitude, Types::Float
        attribute? :horizontal_accuracy, Types::Float
      end
    end
  end
end
