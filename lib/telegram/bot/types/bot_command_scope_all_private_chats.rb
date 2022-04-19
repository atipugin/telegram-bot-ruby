# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeAllPrivateChats < Base
        attribute :type, String, default: 'all_private_chats'
      end
    end
  end
end
