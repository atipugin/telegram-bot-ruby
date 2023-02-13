# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class KeyboardButtonPollType < Base
        attribute? :type, Types::String
      end
    end
  end
end
