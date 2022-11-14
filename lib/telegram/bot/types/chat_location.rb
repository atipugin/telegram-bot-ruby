# frozen_string_literal: true

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
