# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatShared < Base
        attribute :request_id, Types::Integer
        attribute :chat_id, Types::Integer
        attribute? :title, Types::String
        attribute? :username, Types::String
        attribute? :photo, Types::Array.of(PhotoSize)
      end
    end
  end
end
