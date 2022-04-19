# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeChat < Base
        attribute :type, String, default: 'chat'
        attribute :chat_id, String
      end
    end
  end
end
