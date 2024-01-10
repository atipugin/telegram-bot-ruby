# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatBoost < Base
        attribute :boost_id, Types::String
        attribute :add_date, Types::Integer
        attribute :expiration_date, Types::Integer
        attribute :source, ChatBoostSource
      end
    end
  end
end
