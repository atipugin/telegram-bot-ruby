# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeAllChatAdministrators < Base
        attribute :type, Types::String.default('all_chat_administrators')
      end
    end
  end
end
