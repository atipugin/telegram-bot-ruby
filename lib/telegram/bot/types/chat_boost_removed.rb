# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatBoostRemoved < Base
        attribute :chat, Chat
        attribute :boost_id, Types::String
        attribute :remove_date, Types::Integer
        attribute :source, ChatBoostSource
      end
    end
  end
end
