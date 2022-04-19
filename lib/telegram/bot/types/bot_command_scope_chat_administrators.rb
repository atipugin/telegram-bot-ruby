# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeChatAdministrators < Base
        attribute :type, String, default: 'chat_administrators'
        attribute :chat_id, String
      end
    end
  end
end
