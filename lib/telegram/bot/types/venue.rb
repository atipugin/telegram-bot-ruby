# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Venue < Base
        attribute :location, Location
        attribute :title, String
        attribute :address, String
        attribute :foursquare_id, String
        attribute :foursquare_type, String
        attribute :google_place_id, String
        attribute :google_place_type, String
      end
    end
  end
end
