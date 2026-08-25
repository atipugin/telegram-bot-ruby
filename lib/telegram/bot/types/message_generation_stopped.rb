# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class MessageGenerationStopped < Base
        attribute :chat, Chat
        attribute? :message_thread_id, Types::Integer
        attribute :draft_id, Types::Integer
      end
    end
  end
end
