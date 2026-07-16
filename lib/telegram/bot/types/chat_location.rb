# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatLocation < Base
        attribute :location, Location
        attribute :address, Types::String.constrained(min_size: 1, max_size: 64)
      end
    end
  end
end
