# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BusinessOpeningHoursInterval < Base
        attribute :opening_minute, Types::Integer
        attribute :closing_minute, Types::Integer
      end
    end
  end
end
