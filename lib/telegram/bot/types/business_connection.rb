# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BusinessConnection < Base
        attribute :id, Types::String
        attribute :user, User
        attribute :user_chat_id, Types::Integer
        attribute :date, Types::Integer
        attribute :can_reply, Types::Bool
        attribute :is_enabled, Types::Bool
      end
    end
  end
end
