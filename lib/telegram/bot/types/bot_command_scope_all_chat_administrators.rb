module Telegram
  module Bot
    module Types
      class BotCommandScopeAllChatAdministrators < Base
        attribute :type, String, default: 'all_chat_administrators'
      end
    end
  end
end
