# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChosenInlineResult < Base
        attribute :result_id, Types::String
        attribute :from, User
        attribute? :location, Location
        attribute? :inline_message_id, Types::String
        attribute :query, Types::String

        alias to_s query
      end
    end
  end
end
