# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQuery < Base
        attribute :id, String
        attribute :from, User
        attribute :query, String
        attribute :offset, String
        attribute :chat_type, String
        attribute :location, Location

        alias to_s query
      end
    end
  end
end
