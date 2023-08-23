# frozen_string_literal: true

require_relative 'location'

module Telegram
  module Bot
    module Types
      class ChatLocation < Base
        attribute :location, Location
        attribute :address, Types::String
      end
    end
  end
end
