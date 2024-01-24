# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class UsersShared < Base
        attribute :request_id, Types::Integer
        attribute :user_ids, Types::Array.of(Types::Integer)
      end
    end
  end
end
