# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BusinessOpeningHours < Base
        attribute :time_zone_name, Types::String
        attribute :opening_hours, Types::Array.of(BusinessOpeningHoursInterval)
      end
    end
  end
end
