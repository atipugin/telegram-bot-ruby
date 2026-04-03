# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ManagedBotUpdated < Base
        attribute :user, User
        attribute :bot, User
      end
    end
  end
end
