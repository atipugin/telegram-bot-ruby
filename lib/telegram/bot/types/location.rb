# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Location < Base
        attribute :longitude, Float
        attribute :latitude, Float
        attribute :horizontal_accuracy, Float
        attribute :live_period, Integer
        attribute :heading, Integer
        attribute :proximity_alert_radius, Integer
      end
    end
  end
end
