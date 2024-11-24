# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BackgroundTypeWallpaper < Base
        attribute :type, Types::String.constrained(eql: 'wallpaper').default('wallpaper')
        attribute :document, Document
        attribute :dark_theme_dimming, Types::Integer
        attribute? :is_blurred, Types::True
        attribute? :is_moving, Types::True
      end
    end
  end
end
