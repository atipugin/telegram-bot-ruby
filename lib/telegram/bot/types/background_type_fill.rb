# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BackgroundTypeFill < Base
        attribute :type, Types::String.default('fill')
        attribute :fill, BackgroundFill
        attribute :dark_theme_dimming, Types::Integer
      end
    end
  end
end
