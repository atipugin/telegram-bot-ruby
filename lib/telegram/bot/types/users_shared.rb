# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UsersShared < Base
        attribute :request_id, Types::Integer
        attribute :users, Types::Array.of(SharedUser)
      end
    end
  end
end
