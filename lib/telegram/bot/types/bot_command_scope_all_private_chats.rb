# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeAllPrivateChats < Base
        attribute :type, Types::String.constrained(eql: 'all_private_chats').default('all_private_chats')
      end
    end
  end
end
