module Telegram
  module Bot
    module Types
      class Venue < Base
        attribute :location, Location
        attribute :title, String
        attribute :address, String
        attribute :foursquare_id, String
        attribute :foursquare_type, String
      end
    end
  end
end
