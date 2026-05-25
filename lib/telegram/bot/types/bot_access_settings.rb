# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotAccessSettings < Base
        attribute :is_access_restricted, Types::Bool
        attribute? :added_users, Types::Array.of(User)
      end
    end
  end
end
