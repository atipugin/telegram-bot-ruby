# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeChat < Base
        attribute :type, Types::String.default('chat')
        attribute :chat_id, Types::String
      end
    end
  end
end
