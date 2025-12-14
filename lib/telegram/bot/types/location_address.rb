# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class LocationAddress < Base
        attribute :country_code, Types::String
        attribute? :state, Types::String
        attribute? :city, Types::String
        attribute? :street, Types::String
      end
    end
  end
end
