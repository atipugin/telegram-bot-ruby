# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InaccessibleMessage < Base
        attribute :chat, Chat
        attribute :message_id, Types::Integer
        attribute :date, Types::Integer
      end
    end
  end
end
