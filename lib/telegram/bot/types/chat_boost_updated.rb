# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatBoostUpdated < Base
        attribute :chat, Chat
        attribute :boost, ChatBoost
      end
    end
  end
end
