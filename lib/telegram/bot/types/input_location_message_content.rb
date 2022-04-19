# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputLocationMessageContent < InputMessageContent
        attribute :latitude, Float
        attribute :longitude, Float
        attribute :horizontal_accuracy, Float
        attribute :live_period, Integer
        attribute :heading, Integer
        attribute :proximity_alert_radius, Integer
      end
    end
  end
end
