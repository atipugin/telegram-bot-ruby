# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class StoryAreaPosition < Base
        attribute :x_percentage, Types::Float
        attribute :y_percentage, Types::Float
        attribute :width_percentage, Types::Float
        attribute :height_percentage, Types::Float
        attribute :rotation_angle, Types::Float
        attribute :corner_radius_percentage, Types::Float
      end
    end
  end
end
