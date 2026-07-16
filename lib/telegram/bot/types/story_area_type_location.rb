# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class StoryAreaTypeLocation < Base
        attribute :type, Types::String.constrained(eql: 'location').default('location')
        attribute :latitude, Types::Float
        attribute :longitude, Types::Float
        attribute? :address, LocationAddress
      end
    end
  end
end
