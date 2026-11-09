# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputLocationMessageContent < Base
        attribute :latitude, Types::Float
        attribute :longitude, Types::Float
        attribute? :horizontal_accuracy, Types::Float
        attribute? :live_period, Types::Integer.constrained(gteq: 60, lteq: 86_400) |
                                 Types::Integer.constrained(eql: 2_147_483_647)
        attribute? :heading, Types::Integer.constrained(gteq: 1, lteq: 360)
        attribute? :proximity_alert_radius, Types::Integer.constrained(gteq: 1, lteq: 100_000)
      end
    end
  end
end
