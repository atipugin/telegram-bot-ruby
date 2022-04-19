# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommand < Base
        attribute :command, String
        attribute :description, String
      end
    end
  end
end
