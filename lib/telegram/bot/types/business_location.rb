# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BusinessLocation < Base
        attribute :address, Types::String
        attribute? :location, Location
      end
    end
  end
end
