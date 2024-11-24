# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Chat < Base
        attribute :id, Types::Integer
        attribute :type, Types::String
        attribute? :title, Types::String
        attribute? :username, Types::String
        attribute? :first_name, Types::String
        attribute? :last_name, Types::String
        attribute? :is_forum, Types::True
      end
    end
  end
end
