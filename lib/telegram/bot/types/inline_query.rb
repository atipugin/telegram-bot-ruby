# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQuery < Base
        attribute :id, Types::String
        attribute :from, User
        attribute :query, Types::String
        attribute :offset, Types::String
        attribute? :chat_type, Types::String
        attribute? :location, Location

        alias to_s query
      end
    end
  end
end
