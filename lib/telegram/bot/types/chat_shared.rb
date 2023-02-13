# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatShared < Base
        attribute :request_id, Types::Integer
        attribute :chat_id, Types::Integer
      end
    end
  end
end
