# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputLocationMessageContent < Base
        attribute :latitude, Types::Float
        attribute :longitude, Types::Float
        attribute? :horizontal_accuracy, Types::Float
        attribute? :live_period, Types::Integer.constrained(min_size: 60, max_size: 86_400)
        attribute? :heading, Types::Integer
        attribute? :proximity_alert_radius, Types::Integer
      end
    end
  end
end
