# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class StoryAreaTypeWeather < Base
        attribute :type, Types::String.constrained(eql: 'weather').default('weather')
        attribute :temperature, Types::Float
        attribute :emoji, Types::String
        attribute :background_color, Types::Integer
      end
    end
  end
end
