# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommand < Base
        attribute :command, Types::String.constrained(min_size: 1, max_size: 32)
        attribute :description, Types::String.constrained(min_size: 1, max_size: 256)
      end
    end
  end
end
