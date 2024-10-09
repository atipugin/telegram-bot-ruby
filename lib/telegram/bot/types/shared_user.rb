# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SharedUser < Base
        attribute :user_id, Types::Integer
        attribute? :first_name, Types::String
        attribute? :last_name, Types::String
        attribute? :username, Types::String
        attribute? :photo, Types::Array.of(PhotoSize)
      end
    end
  end
end
