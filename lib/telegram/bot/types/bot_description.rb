# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotDescription < Base
        attribute :description, Types::String
      end
    end
  end
end
