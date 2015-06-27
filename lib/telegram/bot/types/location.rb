module Telegram
  module Bot
    module Types
      class Location < Base
        attribute :longitude, Float
        attribute :latitude, Float
      end
    end
  end
end
