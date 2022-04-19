# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ProximityAlertTriggered < Base
        attribute :traveler, User
        attribute :watcher, User
        attribute :distance, Integer
      end
    end
  end
end
