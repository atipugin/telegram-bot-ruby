# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ManagedBotCreated < Base
        attribute :bot, User
      end
    end
  end
end
